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

#ifndef TCPRELAYAPP_H_
#define TCPRELAYAPP_H_

#include "INETDefs.h"
#include "ILifecycle.h"
#include "NodeStatus.h"
#include "TCPSocket.h"
#include "TCPSegment.h"
#include "TCPConnection.h"

/**
 * Accepts any number of incoming connections, and sends back whatever
 * arrives on them.
 */

class INET_API TCPRelayApp : public cSimpleModule, public ILifecycle, public TCPSocket::CallbackInterface
{
  protected:
    simtime_t delay;
    double echoFactor;
    double share;
    double inputRate;
    double lastBytesRecv;
    double cost;
    double interval;
    double beta;
    double lgccPhi1;
    double lgccPhi2;

    TCPSocket socket;
    TCPSocket socket2;
    TCPSocket ssocket;
    TCPSocket ssocket2;
    NodeStatus *nodeStatus;

    long bytesRcvd;
    long bytesSent;

    int sendQueueThreshold;

    long sendQueueSize;

    bool reverse;

    char * inGateName = "tcpIn";
    char * inGate2Name = "tcp2In";

    char * outGateName = "tcpOut";
    char * outGate2Name = "tcp2Out";

    typedef std::map<std::string, double> WeightsMap;
    WeightsMap weightMap;
    WeightsMap weightMap2;
    double weightSum;

    typedef std::map<std::string, TCPSocket *> ForwardingMap;
    ForwardingMap forwardingMap;

    char *inGate, *outGate, *inGate2, *outGate2;

    simtime_t lastCalcInputRate;

    static simsignal_t rcvdPkSignal;
    static simsignal_t sentPkSignal;

    cOutVector *costVector;
    cOutVector *markingVector;
    cOutVector *sendBufferVector;

  public:
    virtual bool handleOperationStage(LifecycleOperation *operation, int stage, IDoneCallback *doneCallback);
    TCPSocket* getSendTCPSocket(const char * srcIPAddr);
    const char * getFirstSender(cPacket * pkt);
    long getSendQueueSize(const char * srcIPAddr);
    int getTCPOutGateIndex();
    uint32 getNextRate();
    std::string getNextWeights();
    std::string getNextWeights2();
    void setNextWeights(const char * weights);
    void setNextWeights2(IPvXAddress senderAddr, const char * weights);
    void processRatesAndWeights(TCPConnection *conn, TCPSegment *tcpseg);
    bool processSegment(TCPConnection *conn, TCPSegment *tcpseg);

    bool needToBlock();
    void encapsulateSender(cPacket * pkt, IPvXAddress srcAddr);
    double getMarkingProb(IPvXAddress srcAddr);

  protected:
    virtual bool isNodeUp();
    virtual void sendDown(cMessage *msg);
    virtual void startListening();
    virtual void stopListening();

  protected:
    virtual void initialize(int stage);
    virtual int numInitStages() const { return 4; }
    virtual void handleMessage(cMessage *msg);
    virtual void finish();
    /** @name TCPSocket::CallbackInterface callback methods */
    //@{
    /** Does nothing but update statistics/status. Redefine to perform or schedule first sending. */
    virtual void socketEstablished(int connId, void *yourPtr);

    /**
     * Does nothing but update statistics/status. Redefine to perform or schedule next sending.
     * Beware: this function deletes the incoming message, which might not be what you want.
     */
    virtual void socketDataArrived(int connId, void *yourPtr, cPacket *msg, bool urgent);

    /** Since remote TCP closed, invokes close(). Redefine if you want to do something else. */
    virtual void socketPeerClosed(int connId, void *yourPtr);

    /** Does nothing but update statistics/status. Redefine if you want to do something else, such as opening a new connection. */
    virtual void socketClosed(int connId, void *yourPtr);

    /** Does nothing but update statistics/status. Redefine if you want to try reconnecting after a delay. */
    virtual void socketFailure(int connId, void *yourPtr, int code);

    /** Redefine to handle incoming TCPStatusInfo. */
    virtual void socketStatusArrived(int connId, void *yourPtr, TCPStatusInfo *status) {delete status;}
    //@}

};


#endif /* TCPRELAYAPP_H_ */
