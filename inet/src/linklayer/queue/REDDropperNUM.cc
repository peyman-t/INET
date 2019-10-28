//
// Copyright (C) 2012 Opensim Ltd.
// Author: Tamas Borbely
// Copyright (C) 2013 Thomas Dreibholz
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

#include <iostream>

#include "REDDropperNUM.h"
#include "opp_utils.h"
#include "IPv4Datagram.h"


Define_Module(REDDropperNUM);

REDDropperNUM::~REDDropperNUM()
{
    delete[] minths;
    delete[] maxths;
    delete[] maxps;
    delete[] pkrates;
    delete[] count;
    delete[] marks;
    q_time = 0;

    delete marked;
    delete markedSID;
    delete markedNotSID;
}

void REDDropperNUM::initialize()
{
    AlgorithmicDropperBase::initialize();

    wq = par("wq");
    if (wq < 0.0 || wq > 1.0)
        throw cRuntimeError("Invalid value for wq parameter: %g", wq);

    minths = new double[numGates];
    maxths = new double[numGates];
    maxps = new double[numGates];
    pkrates = new double[numGates];
    count = new double[numGates];
    marks = new double[numGates];

    cStringTokenizer minthTokens(par("minths"));
    cStringTokenizer maxthTokens(par("maxths"));
    cStringTokenizer maxpTokens(par("maxps"));
    cStringTokenizer pkrateTokens(par("pkrates"));
    cStringTokenizer markTokens(par("marks"));
    for (int i = 0; i < numGates; ++i)
    {
        minths[i] = minthTokens.hasMoreTokens() ? OPP_Global::atod(minthTokens.nextToken()) :
                   (i > 0 ? minths[i-1] : 5.0);
        maxths[i] = maxthTokens.hasMoreTokens() ? OPP_Global::atod(maxthTokens.nextToken()) :
                   (i > 0 ? maxths[i-1] : 50.0);
        maxps[i] = maxpTokens.hasMoreTokens() ? OPP_Global::atod(maxpTokens.nextToken()) :
                   (i > 0 ? maxps[i-1] : 0.02);
        pkrates[i] = pkrateTokens.hasMoreTokens() ? OPP_Global::atod(pkrateTokens.nextToken()) :
                    (i > 0 ? pkrates[i-1] : 150);
        marks[i] = markTokens.hasMoreTokens() ? OPP_Global::atod(markTokens.nextToken()) :
                    (i > 0 ? marks[i-1] : 0);
        count[i] = -1;

        if (minths[i] < 0.0)
            throw cRuntimeError("minth parameter must not be negative");
        if (maxths[i] < 0.0)
            throw cRuntimeError("maxth parameter must not be negative");
        if (minths[i] >= maxths[i])
            throw cRuntimeError("minth must be smaller than maxth");
        if (maxps[i] < 0.0 || maxps[i] > 1.0)
            throw cRuntimeError("Invalid value for maxp parameter: %g", maxps[i]);
        if (pkrates[i] < 0.0)
            throw cRuntimeError("Invalid value for pkrates parameter: %g", pkrates[i]);
        if (marks[i] != 0 && marks[i] != 1)
            throw cRuntimeError("Invalid value for marks parameter: %g", marks[i]);
    }

    marked = new cOutVector("marked");
    markedSID = new cOutVector("markedSID");
    markedNotSID = new cOutVector("markedNotSID");

    markingProbSignal = registerSignal("markingProb");
    queueLenSignal = registerSignal("queueLength");

    markNext = false;

    recStart = par("recStart");
}

void REDDropperNUM::markECN(cPacket *packet)
{

    if (isMarkedECN(packet)) {
//        if(getLength() > 0)
            markNext = true;
        return;
    }

    if(!markNext) {
        IPv4Datagram * ipPacket = check_and_cast<IPv4Datagram*>(packet);
        ipPacket->setExplicitCongestionNotification(3);
    } else
        markNext = false;
}

bool REDDropperNUM::isMarkedECN(cPacket *packet)
{
    IPv4Datagram * ipPacket = check_and_cast<IPv4Datagram*>(packet);
    if (ipPacket->getExplicitCongestionNotification() > 0)
        return true;
    return false;
}

bool REDDropperNUM::shouldDrop(cPacket *packet)
{
    const int i = packet->getArrivalGate()->getIndex();
    ASSERT(i >= 0 && i < numGates);
    const double minth = minths[i];
    const double maxth = maxths[i];
    const double maxp = maxps[i];
    const double pkrate = pkrates[i];
    const double mark = marks[i];
    const int queueLength = getLength();

    if(simTime() >= recStart)
        emit(queueLenSignal, queueLength);

    if (queueLength > 0)
    {
        // TD: This following calculation is only useful when the queue is not empty!
        avg = (1 - wq) * avg + wq * queueLength;
    }
    else
    {
        // TD: Added behaviour for empty queue.
        const double m = SIMTIME_DBL(simTime() - q_time) * pkrate;
        avg = pow(1 - wq, m) * avg;
    }


    if (minth <= avg && avg < maxth)
    {
        count[i]++;
        const double pb = maxp * (avg - minth) / (maxth - minth);
        double pa = pb; // TD: Adapted to work as in [Floyd93].
        if (dblrand() < pa)
        {
            EV << "Random early packet drop (avg queue len=" << avg << ", pa=" << pb << ")\n";
            count[i] = 0;
            if(!mark)
                return true;
            else
                markECN(packet);
            //marked->record(1);
            if(simTime() >= recStart)
                emit(markingProbSignal, 1);
            //markedSID->record((check_and_cast<IPv4Datagram*>(packet))->getSrcAddress().getInt());
        } else {
            //marked->record(0);
            if(simTime() >= recStart)
                emit(markingProbSignal, 0);
            //markedNotSID->record((check_and_cast<IPv4Datagram*>(packet))->getSrcAddress().getInt());
        }
    }
    else if (avg >= maxth)
    {
        EV << "Avg queue len " << avg << " >= maxth, dropping packet.\n";
        count[i] = 0;
        if(!mark)
            return true;
        else
            markECN(packet);
        //marked->record(1);
        if(simTime() >= recStart)
            emit(markingProbSignal, 1);
        //markedSID->record((check_and_cast<IPv4Datagram*>(packet))->getSrcAddress().getInt());
    }
    else if (queueLength >= maxth)  // maxth is also the "hard" limit
    {
        EV << "Queue len " << queueLength << " >= maxth, dropping packet.\n";
        count[i] = 0;
        if(!mark)
            return true;
        else
            markECN(packet);
        //marked->record(1);
        if(simTime() >= recStart)
            emit(markingProbSignal, 1);
        //markedSID->record((check_and_cast<IPv4Datagram*>(packet))->getSrcAddress().getInt());
    }
    else
    {
        count[i] = -1;
        //marked->record(0);
        if(simTime() >= recStart)
            emit(markingProbSignal, 0);
        //markedNotSID->record((check_and_cast<IPv4Datagram*>(packet))->getSrcAddress().getInt());
    }

    return false;
}

void REDDropperNUM::sendOut(cPacket *packet)
{
    AlgorithmicDropperBase::sendOut(packet);
    // TD: Set the time stamp q_time when the queue gets empty.
    const int queueLength = getLength();
    if (queueLength == 0)
        q_time = simTime();
}
