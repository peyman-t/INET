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

#include <TCPRelayApp.h>

#include "ByteArrayMessage.h"
#include "TCPCommand_m.h"
#include "ModuleAccess.h"
#include "NodeOperations.h"
#include "IPvXAddress.h"
#include "IPvXAddressResolver.h"
#include "TCP2.h"
#include "TCPConnection.h"

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
        WATCH(bytesRcvd);
        WATCH(bytesSent);

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
        ssocket.readDataTransferModePar(*this);
        ssocket.bind(*localAddress ? IPvXAddressResolver().resolve(localAddress) : IPvXAddress(), localPort);
        ssocket.setCallbackObject(this);
        ssocket.setOutputGate(gate(outGate2)); //"tcp2Out"
        // we need a new connId if this is not the first connection
        ssocket.renewSocket();

        // connect
        const char *connectAddress = par("remoteAddress");
        int connectPort = par("remotePort");

        EV << "issuing OPEN command\n";

        IPvXAddress destination;
        IPvXAddressResolver().tryResolve(connectAddress, destination);


        if (destination.isUnspecified())
            EV << "cannot resolve destination address: " << connectAddress << endl;
        else
            ssocket.connect(destination, connectPort);

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
    ssocket.close();
//    ssocket2.close();
}

void TCPRelayApp::sendDown(cMessage *msg)
{
    if (msg->isPacket())
    {
        bytesSent += ((cPacket *)msg)->getByteLength();
        emit(sentPkSignal, (cPacket *)msg);
    }

    std::string agate = msg->getArrivalGate()->getName();
//    if(agate == "tcp2In")
//        socket.send(msg);
//    else if(agate == "tcpIn")
//        socket2.send(msg);

//    if(agate == "tcp2In")
//        send(msg, "tcp2Out");
//    else if(agate == "tcpIn")
//        send(msg, "tcpOut");

    if(agate == inGate) { //"tcpIn"
        if((msg->getControlInfo() != NULL))
            msg->removeControlInfo();
        ssocket.send(msg);
    }
//    else if(agate == "tcpIn")
//        send(msg, "tcpOut");

}


TCPSocket* TCPRelayApp::getSendTCPSocket() {
    return &ssocket;
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
        delete msg;
        ssocket.close();

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
        pkt->removeControlInfo();

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

void TCPRelayApp::finish()
{
    recordScalar("bytesRcvd", bytesRcvd);
    recordScalar("bytesSent", bytesSent);
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
