//
// Copyright (C) 2012 Opensim Ltd.
// Author: Tamas Borbely
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

package inet.linklayer.queue;

//
// This module implements Random Early Detection (RED).
//
// It has n input and n output gates (specified by the 'numGates'
// parameter). Packets arrived at the ith input gate are
// forwarded to the ith output gate, or dropped. The output
// gates must be connected to simple modules implementing
// the IQueueAccess C++ interface (e.g. FIFOQueue).
//
// The module sums the used buffer space of the queues attached
// to the output gates. If it is below a minimum threshold,
// the packet won't be dropped, if above a maximum threshold,
// it will be dropped, if it is between the minimum and
// maximum threshold, it will be dropped by a given probability.
// This probability determined by a linear function which is
// 0 at the minth and maxp at maxth.
//
// The queue length can be smoothed by specifying the 'wq'
// parameter. The average queue length used in the tests
// are computed by the formula:
//
//  avg = (1-wq)*avg + wq*qlen
//
// The minth, maxth, and maxp parameters can be specified
// separately for each input gate, so this module can be
// used to implement different packet drop priorities.
//
simple REDDropperNUMDual
{
    parameters:
        int numGates = default(1);

        double wq = default(0.002);  // weight of the current queue length in the averaged queue length
        string minths = default("5");  // minimum thresholds for avg queue length (one number for each gate, last one repeated if needed)
        string maxths = default("50");  // maximum thresholds for avg queue length (=buffer capacity) (one number for each gate, last one repeated if needed)
        string maxps = default("0.02");  // maximum value for pbs (one number for each gate, last one repeated if needed)
        string pkrates = default("150");  // average packet rate for calculations when queue is empty
        string marks = default("0");  // average packet rate for calculations when queue is empty
        double recStart = default(0);
        double alpha = default(0.002);
        double beta = default(0.5);
        double phi = default(10);
        @display("i=block/downarrow");
        @signal[markingProb](type=double);
        @statistic[marked](title="marking Prob"; source="markingProb"; record=mean; interpolationmode=none);
        @signal[avgMarkingProb](type=double);
        @statistic[avgMarked](title="avg marking Prob"; source="avgMarkingProb"; record=vector,mean; interpolationmode=none);
        @signal[avgOutputRate](type=double);
        @statistic[avgRate](title="avg output rate"; source="avgOutputRate"; record=vector,mean; interpolationmode=none);

    gates:
        input in[numGates];
        output out[numGates];
}
