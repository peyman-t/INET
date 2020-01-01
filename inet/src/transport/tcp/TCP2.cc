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

#include <TCP2.h>

#include "IPSocket.h"
#include "IPv4ControlInfo.h"
#include "IPv6ControlInfo.h"
#include "LifecycleOperation.h"
#include "ModuleAccess.h"
#include "NodeOperations.h"
#include "NodeStatus.h"
#include "TCPConnection.h"
#include "TCPSegment.h"
#include "TCPCommand_m.h"
#include "IPvXAddressResolver.h"

#ifdef WITH_IPv4
#include "ICMPMessage_m.h"
#endif

#ifdef WITH_IPv6
#include "ICMPv6Message_m.h"
#endif

#include "TCPByteStreamRcvQueue.h"
#include "TCPByteStreamSendQueue.h"
#include "TCPMsgBasedRcvQueue.h"
#include "TCPMsgBasedSendQueue.h"
#include "TCPVirtualDataRcvQueue.h"
#include "TCPVirtualDataSendQueue.h"

#include <TCPRelayApp.h>
#include <TCPBaseAlg.h>
#include <TCP.h>
#include <TCPTahoeRenoFamily.h>
#include "PPP.h"

Define_Module(TCP2);


bool TCP2::testing;
bool TCP2::logverbose;

#define EPHEMERAL_PORTRANGE_START 1024
#define EPHEMERAL_PORTRANGE_END   5000

static std::ostream& operator<<(std::ostream& os, const TCP2::SockPair& sp)
{
    os << "loc=" << IPvXAddress(sp.localAddr) << ":" << sp.localPort << " "
       << "rem=" << IPvXAddress(sp.remoteAddr) << ":" << sp.remotePort;
    return os;
}

static std::ostream& operator<<(std::ostream& os, const TCP2::AppConnKey& app)
{
    os << "connId=" << app.connId << " appGateIndex=" << app.appGateIndex;
    return os;
}

static std::ostream& operator<<(std::ostream& os, const TCPConnection& conn)
{
    os << "connId=" << conn.connId << " " << TCPConnection::stateName(conn.getFsmState())
       << " state={" << const_cast<TCPConnection&>(conn).getState()->info() << "}";
    return os;
}


void TCP2::initialize(int stage)
{
    cSimpleModule::initialize(stage);

    if (stage == 0)
    {
        const char *q;
        q = par("sendQueueClass");
        if (*q != '\0')
            error("Don't use obsolete sendQueueClass = \"%s\" parameter", q);

        q = par("receiveQueueClass");
        if (*q != '\0')
            error("Don't use obsolete receiveQueueClass = \"%s\" parameter", q);

        lastEphemeralPort = EPHEMERAL_PORTRANGE_START;
        WATCH(lastEphemeralPort);

        WATCH_PTRMAP(tcpConnMap);
        WATCH_PTRMAP(tcpAppConnMap);

        recordStatistics = par("recordStats");

        cModule *netw = simulation.getSystemModule();
        testing = netw->hasPar("testing") && netw->par("testing").boolValue();
        logverbose = !testing && netw->hasPar("logverbose") && netw->par("logverbose").boolValue();

        maxRecvWindowVector = new cOutVector("maxRcvBuffer");
        dropPBVector = new cOutVector("dropPBVector");

    }
    else if (stage == 1)
    {
        NodeStatus *nodeStatus = dynamic_cast<NodeStatus *>(findContainingNode(this)->getSubmodule("status"));
        isOperational = (!nodeStatus) || nodeStatus->getState() == NodeStatus::UP;
        IPSocket ipSocket(gate("ipOut"));
        ipSocket.registerProtocol(IP_PROT_TCP2);
        ipSocket.setOutputGate(gate("ipv6Out"));
        ipSocket.registerProtocol(IP_PROT_TCP2);
    }
}

TCP2::~TCP2()
{
    delete maxRecvWindowVector;
    delete dropPBVector;

    while (!tcpAppConnMap.empty())
    {
        TcpAppConnMap::iterator i = tcpAppConnMap.begin();
        delete i->second;
        tcpAppConnMap.erase(i);
    }
}

void TCP2::handleMessage(cMessage *msg)
{
    if (!isOperational)
    {
        if (msg->isSelfMessage())
            throw cRuntimeError("Model error: self msg '%s' received when isOperational is false", msg->getName());
        EV << "TCP is turned off, dropping '" << msg->getName() << "' message\n";
        delete msg;
    }
    else if (msg->isSelfMessage())
    {
        TCPConnection *conn = (TCPConnection *) msg->getContextPointer();
        bool ret = conn->processTimer(msg);
        if (!ret)
            removeConnection(conn);
    }
    else if (msg->arrivedOn("ipIn") || msg->arrivedOn("ipv6In"))
    {
        if (false
#ifdef WITH_IPv4
                || dynamic_cast<ICMPMessage *>(msg)
#endif
#ifdef WITH_IPv6
                || dynamic_cast<ICMPv6Message *>(msg)
#endif
            )
        {
            tcpEV1 << "ICMP error received -- discarding\n"; // FIXME can ICMP packets really make it up to TCP???
            delete msg;
        }
        else
        {
            // must be a TCPSegment
            TCPSegment *tcpseg = check_and_cast<TCPSegment *>(msg);

            // get src/dest addresses
            IPvXAddress srcAddr, destAddr;

            if (dynamic_cast<IPv4ControlInfo *>(tcpseg->getControlInfo()) != NULL)
            {
                IPv4ControlInfo *controlInfo = (IPv4ControlInfo *)tcpseg->getControlInfo();
                srcAddr = controlInfo->getSrcAddr();
                destAddr = controlInfo->getDestAddr();
                tcpseg->setEcnBit(controlInfo->getExplicitCongestionNotification());
//                delete controlInfo;
            }
            else if (dynamic_cast<IPv6ControlInfo *>(tcpseg->getControlInfo()) != NULL)
            {
                IPv6ControlInfo *controlInfo = (IPv6ControlInfo *)tcpseg->getControlInfo();
                srcAddr = controlInfo->getSrcAddr();
                destAddr = controlInfo->getDestAddr();
                tcpseg->setEcnBit(controlInfo->getExplicitCongestionNotification());
//                delete controlInfo;
            }
            else
            {
                error("(%s)%s arrived without control info", tcpseg->getClassName(), tcpseg->getName());
            }

            // process segment
            TCPConnection *conn = findConnForSegment(tcpseg, srcAddr, destAddr);
            if (conn)
            {
                conn->getState()->ecn = tcpseg->getEcnBit();

                std::string strAddr = srcAddr.str();
                EV << "Got TCPSeg from " << strAddr << "\n";

                // Peyman -- original code
//                bool ret = conn->processTCPSegment(tcpseg, srcAddr, destAddr);
//                if (!ret)
//                    removeConnection(conn);

                // Peyman -- pushback
                opp_string str("^.relay[");
                char buf[10];
                sprintf(buf, "%d", conn->appGateIndex);
                str = str + buf;
                str = str + "]";
                TCPRelayApp *relay = dynamic_cast<TCPRelayApp *>(getModuleByPath(str.c_str()));// "appOut", appGateIndex);
                bool dropped = false;
                if(relay != NULL) {
//                        if(par("lgccAggregated")) {
////                            if(strcmp(conn->tcpAlgorithm->getClassName(), "LGCC") == 0) {
////
////                                relay->processRatesAndWeights(conn, tcpseg);
////                                relay->markPacket(tcpseg);
////
////                                if(tcpseg->getEcnBit()) {
////                                    dropPBVector->record(1);
////                                } else
////                                    dropPBVector->record(0);
////
////                            } else {
////
////                                // drop
////                                if(relay->needToBlock()) {
////                                    double dprob = par("param5");
////                                    if (dblrand() < dprob) {
////                                        dropPBVector->record(tcpseg->getSequenceNo());
////                                        delete tcpseg;
////                                        tcpseg = NULL;
////                                    }
////                                }
////                            }

                            dropped = relay->processSegment(conn, tcpseg);
//                            bool ret = conn->processTCPSegment(tcpseg, srcAddr, destAddr);
//                            if (!ret)
//                                removeConnection(conn);

//
//                        } else {
//                            relay->processRatesAndWeights(conn, tcpseg);
////                            relay->processSegment(conn, tcpseg);
//
////                            if(strcmp(conn->tcpAlgorithm->getClassName(), "LGCC") == 0) {
////                                relay->processRatesAndWeights(conn, tcpseg);
////
////                            } else {
////                                if(relay->needToBlock()) {
////                                    conn->getState()->maxRcvBuffer = 3000;
////                                } else
////                                    conn->getState()->maxRcvBuffer = 10000000;
////                            }
//                            conn->getState()->maxRcvBufferChanged = true;
//                            conn->getState()->ecn = tcpseg->getEcnBit();
//                            bool ret = conn->processTCPSegment(tcpseg, srcAddr, destAddr);
//                            if (!ret)
//                                removeConnection(conn);
//                        }
//                        maxRecvWindowVector->record(conn->getState()->maxRcvBuffer);
//
//
                }
                if(!dropped) {
                    conn->getState()->ecn = tcpseg->getEcnBit();
                    bool ret = conn->processTCPSegment(tcpseg, srcAddr, destAddr);
                    if(conn->getState()->ecn)
                        dropPBVector->record(1);
                    else
                        dropPBVector->record(0);
                    if (!ret)
                        removeConnection(conn);

                } else
                    delete tcpseg;
                // Peyman -- pushback -- up to here
            }
            else
            {
                segmentArrivalWhileClosed(tcpseg, srcAddr, destAddr);
            }
        }
    }
    else // must be from app
    {
        TCPCommand *controlInfo = check_and_cast<TCPCommand *>(msg->getControlInfo());
        int appGateIndex = msg->getArrivalGate()->getIndex();
        int connId = controlInfo->getConnId();
//std::string mn = this->getParentModule()->getFullName();
        TCPConnection *conn = findConnForApp(appGateIndex, connId);

        if (!conn)
        {
            conn = createConnection(appGateIndex, connId);

            // add into appConnMap here; it'll be added to connMap during processing
            // the OPEN command in TCPConnection's processAppCommand().
            AppConnKey key;
            key.appGateIndex = appGateIndex;
            key.connId = connId;
            tcpAppConnMap[key] = conn;

            tcpEV1 << "TCP connection created for " << msg << "\n";
        }
        bool ret = conn->processAppCommand(msg);
        if (!ret)
            removeConnection(conn);
    }

    if (ev.isGUI())
        updateDisplayString();
}

TCPConnection *TCP2::createConnection(int appGateIndex, int connId)
{
    return new TCPConnection(this, appGateIndex, connId);
}

void TCP2::segmentArrivalWhileClosed(TCPSegment *tcpseg, IPvXAddress srcAddr, IPvXAddress destAddr)
{
    TCPConnection *tmp = new TCPConnection();
    tmp->segmentArrivalWhileClosed(tcpseg, srcAddr, destAddr);
    delete tmp;
    delete tcpseg;
}

void TCP2::updateDisplayString()
{
    if (ev.isDisabled())
    {
        // in express mode, we don't bother to update the display
        // (std::map's iteration is not very fast if map is large)
        getDisplayString().setTagArg("t", 0, "");
        return;
    }

    //char buf[40];
    //sprintf(buf,"%d conns", tcpAppConnMap.size());
    //getDisplayString().setTagArg("t",0,buf);
    if (isOperational)
        getDisplayString().removeTag("i2");
    else
        getDisplayString().setTagArg("i2", 0, "status/cross");


    int numINIT = 0, numCLOSED = 0, numLISTEN = 0, numSYN_SENT = 0, numSYN_RCVD = 0,
        numESTABLISHED = 0, numCLOSE_WAIT = 0, numLAST_ACK = 0, numFIN_WAIT_1 = 0,
        numFIN_WAIT_2 = 0, numCLOSING = 0, numTIME_WAIT = 0;

    for (TcpAppConnMap::iterator i = tcpAppConnMap.begin(); i != tcpAppConnMap.end(); ++i)
    {
        int state = (*i).second->getFsmState();

        switch (state)
        {
           case TCP_S_INIT:        numINIT++; break;
           case TCP_S_CLOSED:      numCLOSED++; break;
           case TCP_S_LISTEN:      numLISTEN++; break;
           case TCP_S_SYN_SENT:    numSYN_SENT++; break;
           case TCP_S_SYN_RCVD:    numSYN_RCVD++; break;
           case TCP_S_ESTABLISHED: numESTABLISHED++; break;
           case TCP_S_CLOSE_WAIT:  numCLOSE_WAIT++; break;
           case TCP_S_LAST_ACK:    numLAST_ACK++; break;
           case TCP_S_FIN_WAIT_1:  numFIN_WAIT_1++; break;
           case TCP_S_FIN_WAIT_2:  numFIN_WAIT_2++; break;
           case TCP_S_CLOSING:     numCLOSING++; break;
           case TCP_S_TIME_WAIT:   numTIME_WAIT++; break;
        }
    }

    char buf2[200];
    buf2[0] = '\0';

    if (numINIT > 0)       sprintf(buf2+strlen(buf2), "init:%d ", numINIT);
    if (numCLOSED > 0)     sprintf(buf2+strlen(buf2), "closed:%d ", numCLOSED);
    if (numLISTEN > 0)     sprintf(buf2+strlen(buf2), "listen:%d ", numLISTEN);
    if (numSYN_SENT > 0)   sprintf(buf2+strlen(buf2), "syn_sent:%d ", numSYN_SENT);
    if (numSYN_RCVD > 0)   sprintf(buf2+strlen(buf2), "syn_rcvd:%d ", numSYN_RCVD);
    if (numESTABLISHED > 0) sprintf(buf2+strlen(buf2), "estab:%d ", numESTABLISHED);
    if (numCLOSE_WAIT > 0) sprintf(buf2+strlen(buf2), "close_wait:%d ", numCLOSE_WAIT);
    if (numLAST_ACK > 0)   sprintf(buf2+strlen(buf2), "last_ack:%d ", numLAST_ACK);
    if (numFIN_WAIT_1 > 0) sprintf(buf2+strlen(buf2), "fin_wait_1:%d ", numFIN_WAIT_1);
    if (numFIN_WAIT_2 > 0) sprintf(buf2+strlen(buf2), "fin_wait_2:%d ", numFIN_WAIT_2);
    if (numCLOSING > 0)    sprintf(buf2+strlen(buf2), "closing:%d ", numCLOSING);
    if (numTIME_WAIT > 0)  sprintf(buf2+strlen(buf2), "time_wait:%d ", numTIME_WAIT);

    getDisplayString().setTagArg("t", 0, buf2);
}

TCPConnection *TCP2::findConnForSegment(TCPSegment *tcpseg, IPvXAddress srcAddr, IPvXAddress destAddr)
{
    SockPair key;
    key.localAddr = destAddr;
    key.remoteAddr = srcAddr;
    key.localPort = tcpseg->getDestPort();
    key.remotePort = tcpseg->getSrcPort();
    SockPair save = key;

    // try with fully qualified SockPair
    TcpConnMap::iterator i;
    i = tcpConnMap.find(key);

    if (i != tcpConnMap.end())
        return i->second;

    // try with localAddr missing (only localPort specified in passive/active open)
    key.localAddr = IPvXAddress();
    i = tcpConnMap.find(key);

    if (i != tcpConnMap.end())
        return i->second;

    // try fully qualified local socket + blank remote socket (for incoming SYN)
    key = save;
    key.remoteAddr = IPvXAddress();
    key.remotePort = -1;
    i = tcpConnMap.find(key);

    if (i != tcpConnMap.end())
        return i->second;

    // try with blank remote socket, and localAddr missing (for incoming SYN)
    key.localAddr = IPvXAddress();
    i = tcpConnMap.find(key);

    if (i != tcpConnMap.end())
        return i->second;

    // given up
    return NULL;
}

TCPConnection *TCP2::findConnForApp(int appGateIndex, int connId)
{
    AppConnKey key;
    key.appGateIndex = appGateIndex;
    key.connId = connId;

    TcpAppConnMap::iterator i = tcpAppConnMap.find(key);
    return i == tcpAppConnMap.end() ? NULL : i->second;
}

ushort TCP2::getEphemeralPort()
{
    // start at the last allocated port number + 1, and search for an unused one
    ushort searchUntil = lastEphemeralPort++;
    if (lastEphemeralPort == EPHEMERAL_PORTRANGE_END) // wrap
        lastEphemeralPort = EPHEMERAL_PORTRANGE_START;

    while (usedEphemeralPorts.find(lastEphemeralPort) != usedEphemeralPorts.end())
    {
        if (lastEphemeralPort == searchUntil) // got back to starting point?
            error("Ephemeral port range %d..%d exhausted, all ports occupied", EPHEMERAL_PORTRANGE_START, EPHEMERAL_PORTRANGE_END);

        lastEphemeralPort++;

        if (lastEphemeralPort == EPHEMERAL_PORTRANGE_END) // wrap
            lastEphemeralPort = EPHEMERAL_PORTRANGE_START;
    }

    // found a free one, return it
    return lastEphemeralPort;
}

void TCP2::addSockPair(TCPConnection *conn, IPvXAddress localAddr, IPvXAddress remoteAddr, int localPort, int remotePort)
{
    // update addresses/ports in TCPConnection
    SockPair key;
    key.localAddr = conn->localAddr = localAddr;
    key.remoteAddr = conn->remoteAddr = remoteAddr;
    key.localPort = conn->localPort = localPort;
    key.remotePort = conn->remotePort = remotePort;

    // make sure connection is unique
    TcpConnMap::iterator it = tcpConnMap.find(key);
    if (it != tcpConnMap.end())
    {
        // throw "address already in use" error
        if (remoteAddr.isUnspecified() && remotePort == -1)
            error("Address already in use: there is already a connection listening on %s:%d",
                  localAddr.str().c_str(), localPort);
        else
            error("Address already in use: there is already a connection %s:%d to %s:%d",
                  localAddr.str().c_str(), localPort, remoteAddr.str().c_str(), remotePort);
    }

    // then insert it into tcpConnMap
    tcpConnMap[key] = conn;

    // mark port as used
    if (localPort >= EPHEMERAL_PORTRANGE_START && localPort < EPHEMERAL_PORTRANGE_END)
        usedEphemeralPorts.insert(localPort);
}

void TCP2::updateSockPair(TCPConnection *conn, IPvXAddress localAddr, IPvXAddress remoteAddr, int localPort, int remotePort)
{
    // find with existing address/port pair...
    SockPair key;
    key.localAddr = conn->localAddr;
    key.remoteAddr = conn->remoteAddr;
    key.localPort = conn->localPort;
    key.remotePort = conn->remotePort;
    TcpConnMap::iterator it = tcpConnMap.find(key);

    ASSERT(it != tcpConnMap.end() && it->second == conn);

    // ...and remove from the old place in tcpConnMap
    tcpConnMap.erase(it);

    // then update addresses/ports, and re-insert it with new key into tcpConnMap
    key.localAddr = conn->localAddr = localAddr;
    key.remoteAddr = conn->remoteAddr = remoteAddr;
    ASSERT(conn->localPort == localPort);
    key.remotePort = conn->remotePort = remotePort;
    tcpConnMap[key] = conn;

    // localPort doesn't change (see ASSERT above), so there's no need to update usedEphemeralPorts[].
}

void TCP2::addForkedConnection(TCPConnection *conn, TCPConnection *newConn, IPvXAddress localAddr, IPvXAddress remoteAddr, int localPort, int remotePort)
{
    // update conn's socket pair, and register newConn (which'll keep LISTENing)
    updateSockPair(conn, localAddr, remoteAddr, localPort, remotePort);
    addSockPair(newConn, newConn->localAddr, newConn->remoteAddr, newConn->localPort, newConn->remotePort);

    // conn will get a new connId...
    AppConnKey key;
    key.appGateIndex = conn->appGateIndex;
    key.connId = conn->connId;
    tcpAppConnMap.erase(key);
    key.connId = conn->connId = ev.getUniqueNumber();
    tcpAppConnMap[key] = conn;

    // ...and newConn will live on with the old connId
    key.appGateIndex = newConn->appGateIndex;
    key.connId = newConn->connId;
    tcpAppConnMap[key] = newConn;
}

void TCP2::removeConnection(TCPConnection *conn)
{
    tcpEV1 << "Deleting TCP connection\n";

    AppConnKey key;
    key.appGateIndex = conn->appGateIndex;
    key.connId = conn->connId;
    tcpAppConnMap.erase(key);

    SockPair key2;
    key2.localAddr = conn->localAddr;
    key2.remoteAddr = conn->remoteAddr;
    key2.localPort = conn->localPort;
    key2.remotePort = conn->remotePort;
    tcpConnMap.erase(key2);

    // IMPORTANT: usedEphemeralPorts.erase(conn->localPort) is NOT GOOD because it
    // deletes ALL occurrences of the port from the multiset.
    std::multiset<ushort>::iterator it = usedEphemeralPorts.find(conn->localPort);

    if (it != usedEphemeralPorts.end())
        usedEphemeralPorts.erase(it);

    delete conn;
}

void TCP2::finish()
{
    tcpEV1 << getFullPath() << ": finishing with " << tcpConnMap.size() << " connections open.\n";
}

TCPSendQueue* TCP2::createSendQueue(TCPDataTransferMode transferModeP)
{
    switch (transferModeP)
    {
        case TCP_TRANSFER_BYTECOUNT:   return new TCPVirtualDataSendQueue();
        case TCP_TRANSFER_OBJECT:      return new TCPMsgBasedSendQueue();
        case TCP_TRANSFER_BYTESTREAM:  return new TCPByteStreamSendQueue();
        default: throw cRuntimeError("Invalid TCP data transfer mode: %d", transferModeP);
    }
}

TCPReceiveQueue* TCP2::createReceiveQueue(TCPDataTransferMode transferModeP)
{
    switch (transferModeP)
    {
        case TCP_TRANSFER_BYTECOUNT:   return new TCPVirtualDataRcvQueue();
        case TCP_TRANSFER_OBJECT:      return new TCPMsgBasedRcvQueue();
        case TCP_TRANSFER_BYTESTREAM:  return new TCPByteStreamRcvQueue();
        default: throw cRuntimeError("Invalid TCP data transfer mode: %d", transferModeP);
    }
}

bool TCP2::handleOperationStage(LifecycleOperation *operation, int stage, IDoneCallback *doneCallback)
{
    Enter_Method_Silent();

    if (dynamic_cast<NodeStartOperation *>(operation))
    {
        if (stage == NodeStartOperation::STAGE_TRANSPORT_LAYER) {
            //FIXME implementation
            isOperational = true;
            updateDisplayString();
        }
    }
    else if (dynamic_cast<NodeShutdownOperation *>(operation))
    {
        if (stage == NodeShutdownOperation::STAGE_TRANSPORT_LAYER) {
            //FIXME close connections???
            reset();
            isOperational = false;
            updateDisplayString();
        }
    }
    else if (dynamic_cast<NodeCrashOperation *>(operation))
    {
        if (stage == NodeCrashOperation::STAGE_CRASH) {
            //FIXME implementation
            reset();
            isOperational = false;
            updateDisplayString();
        }
    }
    else
    {
        throw cRuntimeError("Unsupported operation '%s'", operation->getClassName());
    }

    return true;
}

void TCP2::reset()
{
    for (TcpAppConnMap::iterator it = tcpAppConnMap.begin(); it != tcpAppConnMap.end(); ++it)
        delete it->second;
    tcpAppConnMap.clear();
    tcpConnMap.clear();
    usedEphemeralPorts.clear();
    lastEphemeralPort = EPHEMERAL_PORTRANGE_START;
}
