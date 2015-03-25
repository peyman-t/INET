//
// author: Thomas Reschka
//

package inet.examples.inet.tcpsplit;

import inet.networklayer.autorouting.ipv4.IPv4NetworkConfigurator;
import inet.nodes.inet.Router;
import inet.nodes.inet.SplitTCPRouter;
import inet.nodes.inet.StandardHost;
import inet.nodes.inet.StandardHost2;
import ned.DatarateChannel;


network tcpsplit
{
    parameters:
        @display("bgb=884,253");
    types:
    submodules:
        router1: SplitTCPRouter {
            parameters:
                @display("p=200,100;i=abstract/router");
            gates:
                pppg[3];
        }
        client: StandardHost2 {
            parameters:
                @display("p=50,100");
            gates:
                pppg[1];
        }
        configurator: IPv4NetworkConfigurator;
        client2: StandardHost2 {
            parameters:
                @display("p=50,200");
            gates:
                pppg[1];
        }
        router2: SplitTCPRouter {
            @display("p=389,110");
            gates:
                pppg[2];
        }
        router3: SplitTCPRouter {
            @display("p=580,110");
            gates:
                pppg[2];
        }
        rcv11: StandardHost2 {
            @display("p=802,85");
            gates:
                pppg[1];
        }
    connections:
        //        router.pppg[0] <--> NormalPath <--> client.pppg[0];
        //        router.pppg[1] <--> NormalPath <--> server.pppg[0];
        //        router.pppg[2] <--> NormalPath <--> client2.pppg[0];
        router1.pppg++ <--> ErroneousPath <--> client.pppg++;
        router1.pppg++ <--> LongPath <--> client2.pppg++;
        router1.pppg++ <--> LongPath <--> router2.pppg++;
        router2.pppg++ <--> LongPath <--> router3.pppg++;
        router3.pppg++ <--> LongPath <--> rcv11.pppg++;
}

channel NormalPath extends DatarateChannel
{
    parameters:
        datarate = 1Mbps;
        delay = 0.0565us; // 10m
        per = 0;
        ber = 0;
}

channel LongPath extends DatarateChannel
{
    parameters:
        datarate = 1Mbps;
        delay = 0.0565us; // 10m
        per = 0;
        ber = 0;
}

channel ErroneousPath extends DatarateChannel
{
    parameters:
        datarate = 1Mbps;
        delay = 0.0565us; // 10m
        per = 0.00;
        ber = 0.00001;
}
