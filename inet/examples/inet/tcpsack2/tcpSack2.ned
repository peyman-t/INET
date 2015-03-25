//
// author: Thomas Reschka
//

package inet.examples.inet.tcpsack2;

import inet.networklayer.autorouting.ipv4.IPv4NetworkConfigurator;
import inet.nodes.inet.Router;
import inet.nodes.inet.SplitTCPRouter;
import inet.nodes.inet.StandardHost;
import inet.nodes.inet.StandardHost2;
import ned.DatarateChannel;


network tcpsack2
{
    parameters:
        @display("bgb=400,253");
    types:
    submodules:
        router: SplitTCPRouter {
            parameters:
                @display("p=200,100;i=abstract/router");
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
                @display("p=319,100");
        }
        client4: StandardHost2 {
            @display("p=313,178");
        }
    connections:
        router.pppg++ <--> LongPath <--> client1.pppg++;
        router.pppg++ <--> LongPath <--> client2.pppg++;
        router.pppg++ <--> LongPath <--> client3.pppg++;
        router.pppg++ <--> LongPath <--> client4.pppg++;
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
