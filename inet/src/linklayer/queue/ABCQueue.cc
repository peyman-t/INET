//
// Copyright (C) 2005 Andras Varga
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program; if not, see <http://www.gnu.org/licenses/>.
//


#include "INETDefs.h"
#include <algorithm>
#include "ABCQueue.h"
#include "PPP.h"
#include "IPv4Datagram.h"

Define_Module(ABCQueue);

simsignal_t ABCQueue::queueLengthSignal = registerSignal("queueLength");
simsignal_t ABCQueue::drainRateSignal = registerSignal("drainRate");
simsignal_t ABCQueue::targetRateSignal = registerSignal("targetRate");
simsignal_t ABCQueue::fSignal = registerSignal("f");

void ABCQueue::initialize()
{
    PassiveQueueBase::initialize();

    queue.setName(par("queueName"));

    //statistics
    emit(queueLengthSignal, queue.length());

    outGate = gate("out");

    // configuration
    frameCapacity = par("frameCapacity");

    no = par("no");
    delayThreshlod = par("delayThreshlod");
    delta = par("delta");
    interval = par("interval");

    drainRate = prevDRate = 1;
    drainRateUpdated = 0;
    sentLength = 0;
    token = 0;
    tokenLimit = 5;
    duration = 0;

}

cMessage *ABCQueue::enqueue(cMessage *msg)
{
    if (frameCapacity && queue.length() >= frameCapacity)
    {
        EV << "Queue full, dropping packet.\n";
        return msg;
    }
    else
    {
        queue.insert(msg);
        emit(queueLengthSignal, queue.length());
        return NULL;
    }
}

cMessage *ABCQueue::dequeue()
{
    if (queue.empty())
        return NULL;

    cMessage *msg = (cMessage *)queue.pop();

    // statistics
    emit(queueLengthSignal, queue.length());

    return msg;
}

void ABCQueue::requestPacket()
{
    Enter_Method("requestPacket()");

    cMessage *msg = dequeue();
    if (msg == NULL)
    {
        packetRequested++;
    }
    else
    {
        emit(dequeuePkSignal, msg);
        emit(queueingTimeSignal, simTime() - msg->getArrivalTime());

        double lastQueuingDelay = simTime().dbl() - msg->getArrivalTime().dbl();
        PPP *ppp = dynamic_cast<PPP *>(getModuleByPath("^.ppp"));
        if(ppp != NULL) {
            linkRate = ppp->getDataRate();
            if(drainRate == 0)
                drainRate = linkRate;
        } else
            linkRate = 1;

        if(simTime() - drainRateUpdated >= interval) {
            drainRateUpdated = simTime();

            double newDRate = (sentLength * 8 / interval);
            if(newDRate > prevDRate)
                drainRate = newDRate;
            else {
                drainRate = newDRate * 0.1 + 0.9 * drainRate;
            }
            prevDRate = newDRate;

//            if(duration > 0)
//                drainRate = sentLength * 8 / duration;
            sentLength = 0;
            duration = 0;
            emit(drainRateSignal, drainRate);
        }

        cPacket *pkt = check_and_cast<cPacket *>(msg);
        sentLength += pkt->getByteLength();

        double len = pkt->getByteLength();
        duration += len * 8 / linkRate;

        targetRate = no * linkRate - (linkRate / delta) * std::max(0.0, lastQueuingDelay - delayThreshlod);

        double f = 0.5 * targetRate / drainRate;//linkRate;

        f = std::min(1.0, std::max(0.0, f));
        token += f;

        if(token > tokenLimit)
            token = tokenLimit;

        IPv4Datagram * ipPacket = check_and_cast<IPv4Datagram*>(pkt);

        if(token > 1) {
            if(ipPacket->getExplicitCongestionNotification() == 0)
                token -= 1;
        } else {
            ipPacket->setExplicitCongestionNotification(3);
        }

        emit(targetRateSignal, targetRate);
        emit(fSignal, f);

        sendOut(msg);
    }
}

void ABCQueue::sendOut(cMessage *msg)
{
    send(msg, outGate);
}

bool ABCQueue::isEmpty()
{
    return queue.empty();
}

