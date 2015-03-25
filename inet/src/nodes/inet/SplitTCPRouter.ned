//
// Copyright (C) 2000 Institut fuer Telematik, Universitaet Karlsruhe
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

package inet.nodes.inet;

import inet.networklayer.bgpv4.BGPRouting;
import inet.networklayer.ospfv2.OSPFRouting;
import inet.networklayer.routing.rip.RIPRouting;
import inet.transport.ITCP;
import inet.transport.IUDP;
import inet.applications.ITCPApp;
import inet.applications.tcpapp.TCPRelayApp;

//
// IPv4 router that supports wireless, Ethernet, PPP and external interfaces.
// By default, no wireless and external interfaces are added; the number of
// Ethernet and PPP ports depends on the external connections.
//
// - Can be connected via ethernet interface to other nodes using
//   the ethg gate. By default full-duplex connections are supported
//   only (twisted pair). Set **.eth.typename="EthernetInterface" for
//   a full/half-duplex CSMA/CD implementation (coaxial cable)
// - By default contains no wireless cards, however it can be configured
//   by the numRadios parameter. Wirless card type is configured by the
//   **.wlan.typename parameter. see:  inet.linklayer.ieee80211 or other
//   modules implementing ~IWirelessNic
// - Also external interfaces can be configured for HW in the loop simulation
//   using the numExtInterfaces parameter and setting the type using
//   **.ext.typename in the INI file. see: ~ExtInterface and ~IExternalNic
// - PPP queueing type can be set using **.ppp.queueType see: ~PPPInterface
// - If wireless card is present, node mobility can be set using **.mobility.typename
//   see: inet.mobility and ~IMobility
//
// By default, dynamic routing is not supported. Specific routing protocols can
// be added by setting the hasOSPF/hasRIP/hasBGP parameters.
//
module SplitTCPRouter extends NodeBase
{
    parameters:
        @display("i=abstract/router;bgb=705,441");
        IPForward = true;
        int numTcpApps = default(0);  // no of TCP apps. Specify the app types in INI file with tcpApp[0..1].typename="TCPEchoApp" syntax
        int numTcp2Apps = default(0);  // no of TCP apps. Specify the app types in INI file with tcpApp[0..1].typename="TCPEchoApp" syntax
        int numRelayApps = default(0);  // no of TCP apps. Specify the app types in INI file with tcpApp[0..1].typename="TCPEchoApp" syntax
        bool hasOSPF = default(false);
        bool hasRIP = default(false);
        bool hasBGP = default(false);
        bool hasRelay = (numRelayApps>0);
        bool hasTCP = (numTcpApps>0) || hasBGP || hasRelay;
        bool hasTCP2 = (numTcp2Apps>0) || hasRelay;
        string tcpType = default(firstAvailable("TCP", "TCP3", "TCP_lwIP", "TCP_NSC", "TCP_None"));  // tcp implementation (e.g. ~TCP, ~TCP_lwIP, ~TCP_NSC) or ~TCPSpoof
        string tcp2Type = default(firstAvailable("TCP2"));  // tcp implementation (e.g. ~TCP, ~TCP_lwIP, ~TCP_NSC) or ~TCPSpoof
        string udpType = default("UDP");
    types:
    submodules:
        ospf: OSPFRouting if hasOSPF {
            parameters:
                @display("p=465,287,row");
        }
        relay[numRelayApps]: TCPRelayApp if hasRelay {
            parameters:
                @display("p=329,41,row");
        }
        bgp: BGPRouting if hasBGP {
            parameters:
                @display("p=558,85;i=block/network");
        }
        rip: RIPRouting if hasRIP {
            @display("p=629,85");
        }

        tcp: <tcpType> like ITCP if hasTCP {
            parameters:
                @display("p=450,180;i=block/transport");
        }
        tcp2: <tcp2Type> like ITCP if hasTCP2 {
            @display("p=208,180;i=block/transport");
        }

        tcpApp[numTcpApps]: <> like ITCPApp {
            parameters:
                @display("p=450,80,row,60");
        }
        tcp2App[numTcp2Apps]: <> like ITCPApp {
            parameters:
                @display("p=208,80,row,60");
        }

        udp: <udpType> like IUDP if hasRIP {
            @display("p=629,180");
        }
    connections allowunconnected:

        if hasOSPF {
            ospf.ipOut --> networkLayer.transportIn++;
            ospf.ipIn <-- networkLayer.transportOut++;
        }

        for i=0..numRelayApps-1 {
            relay[i].tcp2In <-- tcp2.appOut++;
            relay[i].tcp2Out --> tcp2.appIn++;
            relay[i].tcpIn <-- tcp.appOut++;
            relay[i].tcpOut --> tcp.appIn++;
        }

        for i=0..numTcpApps-1 {
            tcpApp[i].tcpOut --> tcp.appIn++;
            tcpApp[i].tcpIn <-- tcp.appOut++;
        }

        for i=0..numTcp2Apps-1 {
            tcp2App[i].tcpOut --> tcp2.appIn++;
            tcp2App[i].tcpIn <-- tcp2.appOut++;
        }

        if hasTCP {
            tcp.ipOut --> networkLayer.transportIn++;
            tcp.ipIn <-- networkLayer.transportOut++;
        }

        if hasTCP2 {
            tcp2.ipOut --> networkLayer.transportIn++;
            tcp2.ipIn <-- networkLayer.transportOut++;
        }

        if hasBGP {
            bgp.tcpOut --> tcp.appIn++;
            bgp.tcpIn <-- tcp.appOut++;
        }

        if hasRIP {
            rip.udpOut --> udp.appIn++;
            rip.udpIn <-- udp.appOut++;

            udp.ipOut --> networkLayer.transportIn++;
            udp.ipIn <-- networkLayer.transportOut++;
        }
}
