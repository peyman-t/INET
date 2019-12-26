//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 
#include <map>
#include <set>

#include <TCPRelayApp.h>

#include "IPv4ControlInfo.h"
#include "IPv6ControlInfo.h"
#include "ByteArrayMessage.h"
#include "TCPCommand_m.h"
#include "ModuleAccess.h"
#include "NodeOperations.h"
#include "IPvXAddress.h"
#include "IPvXAddressResolver.h"
#include "TCP.h"
#include "TCP2.h"
#include "TCPConnection.h"
#include "TCPSendQueue.h"
#include <TCPTahoeRenoFamily.h>
#include <iomanip>
#include <algorithm>
#include "PPP.h"

Define_Module(TCPRelayApp);

simsignal_t TCPRelayApp::rcvdPkSignal = registerSignal("rcvdPk");
simsignal_t TCPRelayApp::sentPkSignal = registerSignal("sentPk");


void TCPRelayApp::initialize(int stage)
{
    cSimpleModule::initialize(stage);

    if (stage == 0)
    {
        delay = par("echoDelay");
        echoFactor = par("echoFactor");
        share = par("share");
        interval = par("interval");
        beta = par("beta");


        reverse = par("reverse");
        if(!reverse) {
            inGate = inGateName;
            outGate = outGateName;
            inGate2 = inGate2Name;
            outGate2 = outGate2Name;
        } else {
            inGate = inGate2Name;
            outGate = outGate2Name;
            inGate2 = inGateName;
            outGate2 = outGateName;
        }

        bytesRcvd = bytesSent = 0;
        sendQueueSize = 0;
        lastBytesRecv = 0;
        lastCalcInputRate = 0;
        cost = 0;
        inputRate = 0;
        sendQueueThreshold = par("sendQueueThreshold");
        WATCH(bytesRcvd);
        WATCH(bytesSent);

        costVector = new cOutVector("costVector");
        markingVector = new cOutVector("markingVector");
        sendBufferVector = new cOutVector("sendBufferVector");

        socket.setOutputGate(gate(outGate)); //"tcpOut"
        socket.readDataTransferModePar(*this);

//        socket2.setOutputGate(gate("tcp2Out"));
//        socket2.readDataTransferModePar(*this);

        nodeStatus = dynamic_cast<NodeStatus *>(findContainingNode(this)->getSubmodule("status"));
    }
    else if (stage == 3)
    {
        if (isNodeUp())
            startListening();

        const char *localAddress = par("localAddress");
        int localPort = par("localPort");

        weightSum = 0;
        const char * weights;
        weights = par("weights");
        int i = 0;
        while(weights[i]) {

            std::string host = "";
            while(weights[i] != '=') {
                host += weights[i];
                i++;
            }
            i++;
            std::string weight = "";
            while(weights[i] != ';') {
                weight += weights[i];
                i++;
            }

            weightSum += std::atof(weight.c_str());
            weightMap.insert(std::pair<std::string, double>(IPvXAddressResolver().resolve(host.c_str()).str(), std::atof(weight.c_str())));

            i++;
        }

        const char * forwarding;
        forwarding = par("forwarding");

        std::string str = "";
        if(strcmp(forwarding, "") == 0) {
            const char *connectAddress = par("remoteAddress");
            int connectPort = par("remotePort");
            str = std::string("*=") + std::string(connectAddress) + std::string(":") + std::to_string(connectPort) + std::string(";");
            forwarding = str.c_str();
        }

        i = 0;
        while(forwarding[i]) {

            std::string src = "";
            while(forwarding[i] != '=') {
                src += forwarding[i];
                i++;
            }
            i++;
            std::string dst = "";
            while(forwarding[i] != ':') {
                dst += forwarding[i];
                i++;
            }
            i++;
            std::string port = "";
            while(forwarding[i] != ';') {
                port += forwarding[i];
                i++;
            }

            TCPSocket * ssocket = NULL;

            ForwardingMap::iterator it;
            for(it = forwardingMap.begin(); it != forwardingMap.end(); it++) {
                TCPSocket * s = it->second;
                IPvXAddress destination;
                IPvXAddressResolver().tryResolve(dst.c_str(), destination);
                IPvXAddress remAddr = s->getRemoteAddress();
                if(remAddr == destination && s->getRemotePort() == std::atoi(port.c_str())) {
                    ssocket = s;
                    break;
                }
            }
            if(ssocket == NULL) {
                ssocket = new TCPSocket();
                // we need a new connId if this is not the first connection
                ssocket->renewSocket();
                ssocket->readDataTransferModePar(*this);
                ssocket->bind(*localAddress ? IPvXAddressResolver().resolve(localAddress) : IPvXAddress(), localPort);
                ssocket->setCallbackObject(this);
                const char * txMode = par("dataTransferMode2");
                if(strcmp(txMode, "bytestream") == 0)
                    ssocket->setDataTransferMode(TCP_TRANSFER_BYTESTREAM);
                else if(strcmp(txMode, "object") == 0)
                    ssocket->setDataTransferMode(TCP_TRANSFER_OBJECT);
                else
                    ssocket->setDataTransferMode(TCP_TRANSFER_BYTECOUNT);
                ssocket->setOutputGate(gate(outGate2)); //"tcp2Out"
                IPvXAddress destination;
                IPvXAddressResolver().tryResolve(dst.c_str(), destination);

                if (destination.isUnspecified())
                    EV << "cannot resolve destination address: " << dst << endl;
                else {
                    ssocket->connect(destination, std::atoi(port.c_str()));
                }
            }
            if(src != "*")
                src = IPvXAddressResolver().resolve(src.c_str()).str();
            forwardingMap.insert(std::pair<std::string, TCPSocket *>(src, ssocket));

            i++;
        }

//        if(forwardingMap.empty()) {
//            ssocket.readDataTransferModePar(*this);
//            ssocket.bind(*localAddress ? IPvXAddressResolver().resolve(localAddress) : IPvXAddress(), localPort);
//            ssocket.setCallbackObject(this);
//
//            const char * txMode = par("dataTransferMode2");
//            if(strcmp(txMode, "bytestream") == 0)
//                ssocket.setDataTransferMode(TCP_TRANSFER_BYTESTREAM);
//            else if(strcmp(txMode, "object") == 0)
//                ssocket.setDataTransferMode(TCP_TRANSFER_OBJECT);
//            else
//                ssocket.setDataTransferMode(TCP_TRANSFER_BYTECOUNT);
//            ssocket.setOutputGate(gate(outGate2)); //"tcp2Out"
//            // we need a new connId if this is not the first connection
//            ssocket.renewSocket();
//
//            // connect
//            const char *connectAddress = par("remoteAddress");
//            int connectPort = par("remotePort");
//
//            EV << "issuing OPEN command\n";
//
//            IPvXAddress destination;
//            IPvXAddressResolver().tryResolve(connectAddress, destination);
//
//
//            if (destination.isUnspecified())
//                EV << "cannot resolve destination address: " << connectAddress << endl;
//            else
//                ssocket.connect(destination, connectPort);
//        }
//
//        ssocket2.readDataTransferModePar(*this);
//        ssocket2.bind(*localAddress ? IPvXAddressResolver().resolve(localAddress) : IPvXAddress(), localPort);
//        ssocket2.setCallbackObject(this);
//        ssocket2.setOutputGate(gate("tcp2Out"));
    }
}

bool TCPRelayApp::isNodeUp()
{
    return !nodeStatus || nodeStatus->getState() == NodeStatus::UP;
}

void TCPRelayApp::startListening()
{
    const char *localAddress = par("localAddress");
    int localPort = par("localPort");
    socket.renewSocket();
    socket.bind(localAddress[0] ? IPvXAddress(localAddress) : IPvXAddress(), localPort);
    socket.listen();

//    socket2.renewSocket();
//    socket2.bind(localAddress[0] ? IPvXAddress(localAddress) : IPvXAddress(), localPort);
//    socket2.listen();
}

void TCPRelayApp::stopListening()
{
    socket.close();
//    socket2.close();
    ForwardingMap::iterator it;
    for(it = forwardingMap.begin(); it != forwardingMap.end(); it++)
        it->second->close();

//    ssocket.close();
//    ssocket2.close();
}

void TCPRelayApp::sendDown(cMessage *msg)
{
    if (msg->isPacket())
    {
        bytesSent += ((cPacket *)msg)->getByteLength();
        emit(sentPkSignal, (cPacket *)msg);
    }

//    std::string agate = msg->getArrivalGate()->getName();

//    if(agate == "tcp2In")
//        socket.send(msg);
//    else if(agate == "tcpIn")
//        socket2.send(msg);

//    if(agate == "tcp2In")
//        send(msg, "tcp2Out");
//    else if(agate == "tcpIn")
//        send(msg, "tcpOut");

//    if(agate == inGate)
    { //"tcpIn"

        cPacket *pkt = check_and_cast<cPacket *>(msg);
        cPacket * cdec = pkt->getEncapsulatedPacket();
        const char * srcIPAddr;
        if(cdec != NULL)
            srcIPAddr = cdec->getName();
        TCPSocket *ssocket = getSendTCPSocket(srcIPAddr);

        if((msg->getControlInfo() != NULL))
            msg->removeControlInfo();
        if(ssocket != NULL)
            ssocket->send(msg);
    }
//    else if(agate == "tcpIn")
//        send(msg, "tcpOut");

}

long TCPRelayApp::getSendQueueSize(const char * srcIPAddr) {
    TCP *tcp = dynamic_cast<TCP *>(getModuleByPath("^.tcp"));
    TCP2 *tcp2 = dynamic_cast<TCP2 *>(getModuleByPath("^.tcp2"));

    TCPConnection *conn1 = NULL;
    TCPSocket *s = getSendTCPSocket(srcIPAddr);
    if(!reverse)
       conn1 = tcp2->findConnForApp(getIndex(), s->getConnectionId());
   else
       conn1 = tcp->findConnForApp(getIndex(), s->getConnectionId());

    if(conn1 != NULL)
        return conn1->getSendQueue()->getBytesAvailable(conn1->getSendQueue()->getBufferStartSeq());
    else
        return 0;
}


TCPSocket* TCPRelayApp::getSendTCPSocket(const char * srcIPAddr) {

    ForwardingMap::iterator it;
    it = forwardingMap.find(srcIPAddr);
    if(it != forwardingMap.end())
        return it->second;
    else {
        it = forwardingMap.find("*");
        if(it != forwardingMap.end())
            return it->second;
        else
            return NULL;
    }
}

bool TCPRelayApp::needToBlock() {
    if(getSendQueueSize("*") > sendQueueThreshold)
        return true;
    return false;
}

uint32 TCPRelayApp::getNextRate() {
    TCPConnection *conn1 = NULL;
    uint32 rate = 0;

    TCP *tcp = dynamic_cast<TCP *>(getModuleByPath("^.tcp"));
    TCP2 *tcp2 = dynamic_cast<TCP2 *>(getModuleByPath("^.tcp2"));

    std::list<TCPConnection *> l;

    ForwardingMap::iterator it;
    for(it = forwardingMap.begin(); it != forwardingMap.end(); it++) {
        TCPSocket *s = getSendTCPSocket(it->first.c_str());
        if(!reverse)
            conn1 = tcp2->findConnForApp(getIndex(), s->getConnectionId());
        else
            conn1 = tcp->findConnForApp(getIndex(), s->getConnectionId());


        auto lit = std::find(l.begin(), l.end(), conn1);
        if (lit == l.end()) {
            l.push_back(conn1);
        } else
            continue;

        if(conn1 != NULL) {
            TCPTahoeRenoFamilyStateVariables *state1 = dynamic_cast<TCPTahoeRenoFamilyStateVariables *>(conn1->getState());
            double connRate = state1->lgcc_rate / 8; // state1->lgcc_rate * state1->lgcc_carryingCap / 8;
//            double sendBufferRate = (double)conn1->getSendQueue()->getBytesAvailable(conn1->getSendQueue()->getBufferStartSeq()) * 8 / state1->minrtt;
//            if(sendBufferRate < connRate)
//                connRate = sendBufferRate;
            rate += connRate;//state1->lgcc_rate * state1->lgcc_carryingCap / 8;
        } else
            return 0;
    }
    return rate;
}

std::string TCPRelayApp::getNextWeights() {
    TCPConnection *conn1 = NULL;
    double rate = 0;
    std::ostringstream weights;

    TCP *tcp = dynamic_cast<TCP *>(getModuleByPath("^.tcp"));
    TCP2 *tcp2 = dynamic_cast<TCP2 *>(getModuleByPath("^.tcp2"));

    ForwardingMap::iterator it;
    for(it = forwardingMap.begin(); it != forwardingMap.end(); it++) {
        TCPSocket *s = getSendTCPSocket(it->first.c_str());
        if(!reverse)
            conn1 = tcp2->findConnForApp(getIndex(), s->getConnectionId());
        else
            conn1 = tcp->findConnForApp(getIndex(), s->getConnectionId());

        if(conn1 != NULL) {
            TCPTahoeRenoFamilyStateVariables *state1 = dynamic_cast<TCPTahoeRenoFamilyStateVariables *>(conn1->getState());
            double connRate = state1->lgcc_rate / 8; // state1->lgcc_rate * state1->lgcc_carryingCap / 8;
//            double sendBufferRate = (double)conn1->getSendQueue()->getBytesAvailable(conn1->getSendQueue()->getBufferStartSeq()) / state1->minrtt;
//            if(sendBufferRate < connRate && sendBufferRate != 0)
//                connRate = sendBufferRate;
            rate += connRate;//state1->lgcc_rate * state1->lgcc_carryingCap / 8;
        }
    }

    weights << std::setprecision(4);
    for(it = forwardingMap.begin(); it != forwardingMap.end(); it++) {
        TCPSocket *s = getSendTCPSocket(it->first.c_str());
        if(!reverse)
            conn1 = tcp2->findConnForApp(getIndex(), s->getConnectionId());
        else
            conn1 = tcp->findConnForApp(getIndex(), s->getConnectionId());

        if(conn1 != NULL) {
            TCPTahoeRenoFamilyStateVariables *state1 = dynamic_cast<TCPTahoeRenoFamilyStateVariables *>(conn1->getState());
            double nextWeight = 0;
            double connRate = state1->lgcc_rate / 8; // state1->lgcc_rate * state1->lgcc_carryingCap / 8;
//            double sendBufferRate = (double)conn1->getSendQueue()->getBytesAvailable(conn1->getSendQueue()->getBufferStartSeq()) / state1->minrtt;
//            if(sendBufferRate < connRate && sendBufferRate != 0)
//                connRate = sendBufferRate;
            nextWeight = connRate / rate;//state1->lgcc_rate * state1->lgcc_carryingCap / 8;
            weights << it->first << "=" << std::to_string(nextWeight) << ";";
        }
    }

    return weights.str();
}

std::string TCPRelayApp::getNextWeights2() {
    std::ostringstream weights;
    WeightsMap::iterator it;
    for(it = weightMap2.begin(); it != weightMap2.end(); it++) {
        weights << it->first << "=" << std::to_string(it->second) << ";";
    }
    return weights.str();
}

const char * TCPRelayApp::getFirstSender(cPacket * pkt) {
    const char * srcIPAddr;
    cPacket * cdec = pkt->getEncapsulatedPacket();
    if(cdec != NULL)
        srcIPAddr = cdec->getName();
    else {
        IPv4ControlInfo *controlInfo = (IPv4ControlInfo *)pkt->getControlInfo();
        srcIPAddr = controlInfo->getSrcAddr().str().c_str();
    }
    return srcIPAddr;
}

void TCPRelayApp::encapsulateSender(cPacket * pkt, IPvXAddress srcAddr) {
    cPacket * cdec = pkt->getEncapsulatedPacket();
    if(cdec == NULL) {
        pkt->encapsulate(new cPacket(srcAddr.str().c_str()));
    }
}

void TCPRelayApp::setNextWeights(const char * weights) {
    int i = 0;
    weightSum = 0;
    while(weights[i]) {

        std::string host = "";
        while(weights[i] != '=') {
            host += weights[i];
            i++;
        }
        i++;
        std::string weight = "";
        while(weights[i] != ';') {
            weight += weights[i];
            i++;
        }

        WeightsMap::iterator it;
        it = weightMap2.find(host);
        if(it != weightMap.end()) {
            it->second = std::atof(weight.c_str());
            weightSum += std::atof(weight.c_str());
        }

        i++;
    }
}

void TCPRelayApp::setNextWeights2(IPvXAddress senderAddr, const char * weights) {

    if(weightMap2.empty()) {
        std::string s = getNextWeights();

        int i = 0;
        const char * weights = s.c_str();
        while(weights[i]) {

            std::string host = "";
            while(weights[i] != '=') {
                host += weights[i];
                i++;
            }
            i++;
            std::string weight = "";
            while(weights[i] != ';') {
                weight += weights[i];
                i++;
            }

            WeightsMap::iterator it;
            it = weightMap2.find(host);
            if(it != weightMap2.end()) {
                it->second = std::atof(weight.c_str());
            } else {
                weightMap2.insert(std::pair<std::string, double>(host, std::atof(weight.c_str())));
            }

            i++;
        }
    }

    if(strcmp(weights, "") == 0) {
        std::string s = getNextWeights();

        int i = 0;
        const char * weights = s.c_str();
        while(weights[i]) {

            std::string host = "";
            while(weights[i] != '=') {
                host += weights[i];
                i++;
            }
            i++;
            std::string weight = "";
            while(weights[i] != ';') {
                weight += weights[i];
                i++;
            }

            TCPSocket * s = getSendTCPSocket(host.c_str());
            if(senderAddr.str() == s->getRemoteAddress().str()) {
                WeightsMap::iterator it = weightMap2.find(host);
                if(it != weightMap2.end()) {
                    it->second = std::atof(weight.c_str());
                }
                break;
            }

            i++;
        }

    } else {
        int i = 0;
        double weightSum = 0;
        double weightSum2 = 0;
        while(weights[i]) {

            std::string host = "";
            while(weights[i] != '=') {
                host += weights[i];
                i++;
            }
            i++;
            std::string weight = "";
            while(weights[i] != ';') {
                weight += weights[i];
                i++;
            }

            WeightsMap::iterator it = weightMap2.find(host);
            if(it != weightMap2.end()) {
                weightSum += std::atof(weight.c_str());
                weightSum2 += it->second;
            }
            i++;
        }
        i = 0;
        while(weights[i]) {

            std::string host = "";
            while(weights[i] != '=') {
                host += weights[i];
                i++;
            }
            i++;
            std::string weight = "";
            while(weights[i] != ';') {
                weight += weights[i];
                i++;
            }

            WeightsMap::iterator it = weightMap2.find(host);
            if(it != weightMap2.end()) {
                it->second = weightSum2 * std::atof(weight.c_str()) / weightSum;
            }
            i++;
        }
    }

    weightSum = 0;
    WeightsMap::iterator it;
    for(it = weightMap.begin(); it != weightMap.end(); it++) {
        WeightsMap::iterator it2 = weightMap2.find(it->first);
        if(it2 != weightMap2.end()) {
            it->second = it2->second;
        }
        weightSum += it->second;
    }

}

void TCPRelayApp::processRatesAndWeights(TCPConnection *conn, TCPSegment *tcpseg) {
    IPvXAddress srcAddr;

    if (dynamic_cast<IPv4ControlInfo *>(tcpseg->getControlInfo()) != NULL)
    {
        IPv4ControlInfo *controlInfo = (IPv4ControlInfo *)tcpseg->getControlInfo();
        srcAddr = controlInfo->getSrcAddr();
    }
    else if (dynamic_cast<IPv6ControlInfo *>(tcpseg->getControlInfo()) != NULL)
    {
        IPv6ControlInfo *controlInfo = (IPv6ControlInfo *)tcpseg->getControlInfo();
        srcAddr = controlInfo->getSrcAddr();
    }

    ForwardingMap::iterator it;
    for(it = forwardingMap.begin(); it != forwardingMap.end(); it++) {
        if(it->second->getRemoteAddress() == srcAddr) {
            std::string nextWeights = "";
            cPacket * cdec = tcpseg->getEncapsulatedPacket();
            if(cdec != NULL)
                nextWeights = std::string(cdec->getName());

//            if(nextWeights != "")
//                setNextWeights(nextWeights.c_str());
            setNextWeights2(srcAddr, nextWeights.c_str());
            return;
        }
    }

    conn->getState()->maxRcvBuffer = getNextRate();
    TCPTahoeRenoFamilyStateVariables *state1 = dynamic_cast<TCPTahoeRenoFamilyStateVariables *>(conn->getState());
//    state1->weights = getNextWeights();
    state1->weights = getNextWeights2();
    if(conn->getState()->maxRcvBuffer < 3000)
        conn->getState()->maxRcvBuffer = 3000;
    conn->getState()->maxRcvBufferChanged = true;

}

bool TCPRelayApp::processSegment(TCPConnection *conn, TCPSegment *tcpseg) {
    if(strcmp(conn->tcpAlgorithm->getClassName(), "LGCC") == 0) {
        processRatesAndWeights(conn, tcpseg);
//        markPacket(tcpseg);

    } else {
        if(needToBlock()) {
            if(weightMap.size() > 1) {
                double dprob = 0.05;
                if (dblrand() < dprob) {
                    return true;
                }
            } else {
                conn->getState()->maxRcvBuffer = 3000;
                conn->getState()->maxRcvBufferChanged = true;
            }
        } else {
            conn->getState()->maxRcvBuffer = 10000000;
            conn->getState()->maxRcvBufferChanged = true;
        }
    }
    return false;
}

void TCPRelayApp::handleMessage(cMessage *msg)
{
    if (!isNodeUp())
        throw cRuntimeError("Application is not running");
    if (msg->isSelfMessage())
    {
        sendDown(msg);
    }
    else if (msg->getKind() == TCP_I_PEER_CLOSED)
    {
        // we'll close too
//        msg->setName("close");
//        msg->setKind(TCP_C_CLOSE);
        std::string agate = msg->getArrivalGate()->getName();
        if(agate == outGate)
            ssocket.close();
        delete msg;

    }
    else if (msg->getKind() == TCP_I_DATA || msg->getKind() == TCP_I_URGENT_DATA)
    {
//        int i = 0;
//        IPvXAddress destination;
//        while(simulation.getModule(++i) != NULL) {
//            if(!simulation.getModule(i)->getSubmodule("interfaceTable"))
//                continue;
//            const char* mn2 = simulation.getModule(i)->getFullName();
//            EV << mn2  << endl;
//            IPvXAddressResolver().tryResolve(mn2, destination);
//            if (destination.isUnspecified())
//                EV << "cannot resolve destination address: " << mn2 << endl;
//            else
//                EV << "resolved : " << mn2 << destination.get4() << endl;
//        }

        cPacket *pkt = check_and_cast<cPacket *>(msg);
        emit(rcvdPkSignal, pkt);
        bytesRcvd += pkt->getByteLength();
        lastBytesRecv += pkt->getByteLength();
//        TCPCommand *controlInfo = (TCPCommand *)pkt->getControlInfo();
//        IPvXAddress srcAddr = controlInfo->getSrcAddr();
//
        std::string srcIPAddr = "";
        cPacket * cdec = pkt->getEncapsulatedPacket();
        if(cdec != NULL)
            srcIPAddr = std::string(cdec->getName());
//        else {
//            srcIPAddr = srcAddr.str();
//            pkt->encapsulate(new cPacket(srcIPAddr.c_str()));
//        }

        TCP *tcp = dynamic_cast<TCP *>(getModuleByPath("^.tcp"));
        TCP2 *tcp2 = dynamic_cast<TCP2 *>(getModuleByPath("^.tcp2"));
        TCPConnection *conn1 = NULL;
//        if(reverse)
//            conn1 = tcp2->findConnForApp(0, controlInfo->getConnId());
//        else
//            conn1 = tcp->findConnForApp(0, controlInfo->getConnId());
//
//        srcIPAddr = conn1->remoteAddr.str();

        pkt->removeControlInfo();
//        ByteArrayMessage *msg2 = new ByteArrayMessage("data1");
//        unsigned char *ptr = new unsigned char[4];
//
//        for (int i = 0; i < 4; i++)
//            ptr[i] = srcAddr.str()[i];
//
//        msg2->getByteArray().assignBuffer(ptr, 4);
//        msg2->setByteLength(pkt->getByteLength());
//
//        delete msg2;
//        delete pkt;
//        pkt = msg2;

        simtime_t now1 = simTime();

        if(now1 - lastCalcInputRate >= interval){
//            TCP *tcp = dynamic_cast<TCP *>(getModuleByPath("^.tcp"));
//            TCP2 *tcp2 = dynamic_cast<TCP2 *>(getModuleByPath("^.tcp2"));
            TCPConnection *conn1 = NULL;
            TCPSocket * socket = getSendTCPSocket(srcIPAddr.c_str());

            if(socket != NULL) {
                if(!reverse)
                    conn1 = tcp2->findConnForApp(getIndex(), socket->getConnectionId());
                else
                    conn1 = tcp->findConnForApp(getIndex(), socket->getConnectionId());
                if (sendBufferVector)
                    sendBufferVector->record(conn1->getSendQueue()->getBytesAvailable(conn1->getSendQueue()->getBufferStartSeq()));

                inputRate = (lastBytesRecv) * 8 / (now1 - lastCalcInputRate);
                lastBytesRecv = 0;
                lastCalcInputRate = now1;

                if(strcmp(conn1->tcpAlgorithm->getClassName(), "LGCC") == 0) {
                    TCPTahoeRenoFamilyStateVariables *state1 = dynamic_cast<TCPTahoeRenoFamilyStateVariables *>(conn1->getState());
    //                double a = 0;
    //                if(cost == 0)
    //                    a = std::max(0.0, inputRate - state1->lgcc_rate * state1->lgcc_carryingCap);
    //                else
    //                    a = inputRate - state1->lgcc_rate * state1->lgcc_carryingCap;

    //                double backloggedRate = (double)conn1->getSendQueue()->getBytesAvailable(conn1->getSendQueue()->getBufferStartSeq()) * 8 / interval;
                    double outputRate = state1->lgcc_rate; // (state1->lgcc_rate * state1->lgcc_carryingCap);
    //                outputRate = outputRate - backloggedRate;
    //                if(outputRate <= 0)
    //                    outputRate = 1;

                    cost = std::max(0.0, std::min(1.0, cost + beta * (inputRate - outputRate) / (outputRate)));



                    if (costVector)
                        costVector->record(cost);

                }
            }

        }

//        TCPCommand *ind = check_and_cast<TCPCommand *>(pkt->removeControlInfo());
//        EV << "connection id : " << ind->getConnId() <<endl;
//        EV << this->getFullName() << endl;
//        EV << this->getParentModule()->getModuleByPath(".tcp")->getFullPath() << endl;
//        TCP2 * tcp2 = check_and_cast<TCP2 *>(this->getParentModule()->getModuleByPath(".tcp2"));
//        EV << this->getParentModule()->findGate("tcp2In") << endl;
//        int id = tcp2->findGate("appIn");
//        TCPConnection *conn = tcp2->findConnForApp(0, ind->getConnId());
//        EV << conn->connId << endl;
//        EV << conn->remoteAddr.get4() << endl;
//        cPacket *msgOut = NULL;
//        msgOut = new cPacket("data1");
//        msgOut->setByteLength(pkt->getByteLength());
//        delete pkt;

        if (delay == 0)
            sendDown(pkt);
        else
            scheduleAt(simTime() + delay, pkt); // send after a delay
    }
    else
    {
        // some indication -- ignore
        delete msg;
    }

//    TCP *tcp = dynamic_cast<TCP *>(getModuleByPath("^.tcp"));
//    TCP2 *tcp2 = dynamic_cast<TCP2 *>(getModuleByPath("^.tcp2"));
//    TCPConnection *conn1 = NULL;
//    if(!reverse)
//        conn1 = tcp2->findConnForApp(0, getSendTCPSocket()->getConnectionId());
//    else
//        conn1 = tcp->findConnForApp(0, getSendTCPSocket()->getConnectionId());
//
//    if(conn1 != NULL)
//        sendQueueSize = (long)(conn1->getSendQueue()->getBytesAvailable(0));

//    simtime_t now = simTime();
//    simtime_t r1 = 10;
//    simtime_t r2 = 15;
//    if(r1 < now && now < r2) {
//        PPP *ppp = dynamic_cast<PPP *>(getModuleByPath("dumbbellAgg.routerEg.ppp[1].ppp"));
//        if(ppp != NULL) {
//            ppp->setDataRate(1000000);
//        }
//    } else {
//        PPP *ppp = dynamic_cast<PPP *>(getModuleByPath("dumbbellAgg.routerEg.ppp[1].ppp"));
//        if(ppp != NULL) {
//            ppp->setDataRate(10000000);
//        }
//    }

    if (ev.isGUI())
    {
        char buf[80];
        sprintf(buf, "rcvd: %ld bytes\nsent: %ld bytes", bytesRcvd, bytesSent);
        getDisplayString().setTagArg("t", 0, buf);
    }
}

bool TCPRelayApp::handleOperationStage(LifecycleOperation *operation, int stage, IDoneCallback *doneCallback)
{
    Enter_Method_Silent();
    if (dynamic_cast<NodeStartOperation *>(operation)) {
        if (stage == NodeStartOperation::STAGE_APPLICATION_LAYER)
            startListening();
    }
    else if (dynamic_cast<NodeShutdownOperation *>(operation)) {
        if (stage == NodeShutdownOperation::STAGE_APPLICATION_LAYER)
            // TODO: wait until socket is closed
            stopListening();
    }
    else if (dynamic_cast<NodeCrashOperation *>(operation)) ;
    else throw cRuntimeError("Unsupported lifecycle operation '%s'", operation->getClassName());
    return true;
}

double TCPRelayApp::getMarkingProb(IPvXAddress srcAddr) {
    double mp = 1;

    if(weightMap.empty())
        mp = 1;
    else {
        WeightsMap::iterator it;
        it = weightMap.find(srcAddr.str());
        if(it != weightMap.end())
            mp = (it->second / weightSum);
        else
            mp = 1;
    }

    TCP *tcp = dynamic_cast<TCP *>(getModuleByPath("^.tcp"));
    TCP2 *tcp2 = dynamic_cast<TCP2 *>(getModuleByPath("^.tcp2"));
    if(!reverse) {
        lgccPhi1 = tcp->par("lgccPhi1");
        lgccPhi2 = tcp->par("lgccPhi2");
    } else {
        lgccPhi1 = tcp2->par("lgccPhi1");
        lgccPhi2 = tcp2->par("lgccPhi2");
    }

    mp = 1 - exp(log(mp) * log(lgccPhi2) / log(lgccPhi1));

    if(getSendQueueSize(srcAddr.str().c_str()) > sendQueueThreshold)
        mp += ((double)getSendQueueSize(srcAddr.str().c_str()) - sendQueueThreshold) / (10 * sendQueueThreshold);

    markingVector->record(mp);

    return mp;
}

void TCPRelayApp::finish()
{
    recordScalar("bytesRcvd", bytesRcvd);
    recordScalar("bytesSent", bytesSent);

    ForwardingMap::iterator it;
    for(it = forwardingMap.begin(); it != forwardingMap.end(); it++) {
        TCPSocket * s = it->second;
        if(it->second) {
            ForwardingMap::iterator it2;
            for(it2 = forwardingMap.begin(); it2 != forwardingMap.end(); it2++) {
                if(it2->second == s)
                    it2->second = NULL;
            }
            delete s;
        }
    }

    delete costVector;
    delete markingVector;
    delete sendBufferVector;
}

void TCPRelayApp::socketEstablished(int, void *)
{
    // *redefine* to perform or schedule first sending
    EV << "connected\n";
//    setStatusString("connected");
}

void TCPRelayApp::socketDataArrived(int, void *, cPacket *msg, bool)
{
    // *redefine* to perform or schedule next sending
//    packetsRcvd++;
//    bytesRcvd += msg->getByteLength();
//    emit(rcvdPkSignal, msg);
    delete msg;
}

void TCPRelayApp::socketPeerClosed(int, void *)
{
//    // close the connection (if not already closed)
//    if (socket.getState() == TCPSocket::PEER_CLOSED)
//    {
//        EV << "remote TCP closed, closing here as well\n";
//        close();
//    }
}

void TCPRelayApp::socketClosed(int, void *)
{
    // *redefine* to start another session etc.
    EV << "connection closed\n";
//    setStatusString("closed");
}

void TCPRelayApp::socketFailure(int, void *, int code)
{
    // subclasses may override this function, and add code try to reconnect after a delay.
    EV << "connection broken\n";
}


int TCPRelayApp::getTCPOutGateIndex() {
    return ssocket.getGateIndex();
}


