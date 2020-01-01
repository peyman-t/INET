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


#ifndef __INET_ABCQUEUE_H
#define __INET_ABCQUEUE_H

#include "INETDefs.h"

#include "PassiveQueueBase.h"

/**
 * Drop-front queue. See NED for more info.
 */
class INET_API ABCQueue : public PassiveQueueBase
{
  protected:
    // configuration
    int frameCapacity;

    double targetRate;
    double no;
    double delta;
    double delayThreshlod;
    double linkRate;

    double drainRate;
    double prevDRate;
    double interval;
    double duration;

    simtime_t drainRateUpdated;
    double sentLength;

    double token, tokenLimit;


    // state
    cQueue queue;
    cGate *outGate;

    // statistics
    static simsignal_t queueLengthSignal;
    static simsignal_t drainRateSignal;
    static simsignal_t targetRateSignal;
    static simsignal_t fSignal;


  protected:
    virtual void initialize();

    /**
     * Redefined from PassiveQueueBase.
     */
    virtual cMessage *enqueue(cMessage *msg);

    /**
     * Redefined from PassiveQueueBase.
     */
    virtual cMessage *dequeue();

    virtual void requestPacket();

    /**
     * Redefined from PassiveQueueBase.
     */
    virtual void sendOut(cMessage *msg);

    /**
     * Redefined from IPassiveQueue.
     */
    virtual bool isEmpty();
};

#endif
