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


package inet.linklayer.queue;

import inet.linklayer.IOutputQueue;


//
// Drop-tail queue, to be used in network interfaces.
// Conforms to the ~IOutputQueue interface.
//
simple ABCQueue like IOutputQueue
{
    parameters:
        int frameCapacity = default(100);
        string queueName = default("l2queue"); // name of the inner cQueue object, used in the 'q' tag of the display string
        double no = default(0.98);
        double delta = default(0.001); // Largest RTT
        double delayThreshlod = default(0.001);
        double interval = default(0.001);
        
        @display("i=block/queue");
        @signal[rcvdPk](type=cPacket);
        @signal[enqueuePk](type=cPacket);
        @signal[dequeuePk](type=cPacket);
        @signal[dropPkByQueue](type=cPacket);
        @signal[queueingTime](type=simtime_t; unit=s);
        @signal[queueLength](type=long);
        @signal[drainRate](type=double);
        @signal[targetRate](type=double);
        @signal[f](type=double);
        @statistic[rcvdPk](title="received packets"; record=count,"sum(packetBytes)","vector(packetBytes)"; interpolationmode=none);
        @statistic[dropPk](title="dropped packets"; source=dropPkByQueue; record=count,"sum(packetBytes)","vector(packetBytes)"; interpolationmode=none);
        @statistic[queueingTime](title="queueing time"; record=histogram,vector; interpolationmode=none);
        @statistic[queueLength](title="queue length"; record=max,timeavg,vector; interpolationmode=sample-hold);
        @statistic[drainRate](title="drain Rate"; record=vector; interpolationmode=sample-hold);
        @statistic[targetRate](title="target Rate"; record=vector; interpolationmode=sample-hold);
        @statistic[f](title="f"; record=vector; interpolationmode=sample-hold);
                gates:
        input in;
        output out;
}

