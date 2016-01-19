//
// author: Thomas Reschka
//

package inet.examples.inet.DCTCP;

import inet.networklayer.autorouting.ipv4.IPv4NetworkConfigurator;
import inet.nodes.inet.Router;
import inet.nodes.inet.SplitTCPRouter;
import inet.nodes.inet.StandardHost;
import inet.nodes.inet.StandardHost2;
import ned.DatarateChannel;

import inet.linklayer.IOutputQueue;
import inet.linklayer.queue.DropTailQueue;
import inet.linklayer.queue.FIFOQueue;
import inet.linklayer.queue.REDDropper;

network DCTCPIncast
{
    parameters:
        @display("bgb=637,253");
        double ldelay @unit(s) = default(0.1s);
    types:
        channel SlowP extends DatarateChannel
        {
            parameters:
                datarate = 2Mbps;
                per = 0;
                ber = 0;
        }
        channel NormalP extends DatarateChannel
        {
            parameters:
                datarate = 10Mbps;
                per = 0;
                ber = 0;
        }
        channel HighSpeedP extends DatarateChannel
        {
            parameters:
                datarate = 20Mbps;
                per = 0;
                ber = 0;
        }

    submodules:
        routerCore: SplitTCPRouter {
            parameters:
                @display("p=291,147;i=abstract/router");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=50,100");
        }
        configurator: IPv4NetworkConfigurator;
        client21: StandardHost2 {
            parameters:
                @display("p=581,100");
        }
    connections:
        routerCore.pppg++ <--> NormalP {  delay = ldelay; } <--> client11.pppg++;
        routerCore.pppg++ <--> NormalP {  delay = ldelay; } <--> client21.pppg++;
}

channel NormalPath extends DatarateChannel
{
    parameters:
        datarate = 10Mbps;
        delay = 25ms; // 10m
        per = 0;
        ber = 0;
}

channel HighSpeedPath extends DatarateChannel
{
    parameters:
        datarate = 20Mbps;
        delay = 25ms; // 10m
        per = 0;
        ber = 0;
}

channel SlowPath extends DatarateChannel
{
    parameters:
        datarate = 2Mbps;
        delay = 25ms; // 10m
        per = 0;
        ber = 0;
}

channel ErroneousPath extends DatarateChannel
{
    parameters:
        datarate = 1Mbps;
        delay = 100ms; // 10m
        per = 0.00;
        ber = 0.000001;
}
