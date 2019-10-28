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

#ifndef __INET_REDDROPPERNUMDUAL2_H_
#define __INET_REDDROPPERNUMDUAL2_H_

#include "INETDefs.h"
#include "AlgorithmicDropperBase.h"

/**
 * Implementation of Random Early Detection (RED).
 */
class REDDropperNUMDual2 : public AlgorithmicDropperBase
{
  protected:
    bool markNext;

    double wq;
    double *minths;
    double *maxths;
    double *maxps;
    double *pkrates;
    double *count;
    double *marks;
    double recStart;
    double alpha;
    double beta;
    double phi;

    double p;

    double curRate;
    double avgRate;

    double avg;
    simtime_t q_time;
    simtime_t r_time;

    cOutVector *marked;
    cOutVector *markedSID;
    cOutVector *markedNotSID;

    simsignal_t markingProbSignal;
    simsignal_t avgMarkingProbSignal;
    simsignal_t avgOutputRateSignal;

  public:
    REDDropperNUMDual2() : wq(0), minths(NULL), maxths(NULL), maxps(NULL), avg(0.0), p(0.01), curRate(0.0), avgRate(0.0) {marked = markedSID = markedNotSID = NULL;}

    void markECN(cPacket *packet);
    bool isMarkedECN(cPacket *packet);
  protected:
    virtual ~REDDropperNUMDual2();
    virtual void initialize();
    virtual bool shouldDrop(cPacket *packet);
    virtual void sendOut(cPacket *packet);
};

#endif
