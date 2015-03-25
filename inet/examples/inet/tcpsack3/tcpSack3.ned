//
// author: Thomas Reschka
//

package inet.examples.inet.tcpsack3;

import inet.networklayer.autorouting.ipv4.IPv4NetworkConfigurator;
import inet.nodes.inet.Router;
import inet.nodes.inet.SplitTCPRouter;
import inet.nodes.inet.StandardHost;
import inet.nodes.inet.StandardHost2;
import ned.DatarateChannel;


network tcpsack3
{
    parameters:
        @display("bgb=637,253");
    types:
    submodules:
        routerIng: SplitTCPRouter {
            parameters:
                @display("p=163,147;i=abstract/router");
        }
        routerCore: SplitTCPRouter {
            parameters:
                @display("p=291,147;i=abstract/router");
        }
        routerEg: SplitTCPRouter {
            parameters:
                @display("p=426,147;i=abstract/router");
        }
        client1: StandardHost2 {
            parameters:
                @display("p=50,100");
        }
        configurator: IPv4NetworkConfigurator;
        client2: StandardHost2 {
            parameters:
                @display("p=50,200");
        }
        client3: StandardHost2 {
            parameters:
                @display("p=581,100");
        }
        client4: StandardHost2 {
            @display("p=581,200");
        }
    connections:
        routerIng.pppg++ <--> NormalPath <--> client1.pppg++;
        routerIng.pppg++ <--> NormalPath <--> client2.pppg++;
        
        routerIng.pppg++ <--> NormalPath <--> routerCore.pppg++;
        routerCore.pppg++ <--> NormalPath <--> routerEg.pppg++;

        routerEg.pppg++ <--> NormalPath <--> client3.pppg++;
        routerEg.pppg++ <--> ErroneousPath <--> client4.pppg++;
}

channel NormalPath extends DatarateChannel
{
    parameters:
        datarate = 1Mbps;
        delay = 1us; // 10m
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
        delay = 1us; // 10m
        per = 0.00;
        ber = 0.0001;
}
