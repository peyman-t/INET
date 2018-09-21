//
// author: Thomas Reschka
//

package inet.examples.inet.LGCC;

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



network dumbbellAgg
{
    parameters:
        @display("bgb=637,337");
        double ldelay @unit(s) = default(0.01s);
        double ldatarate @unit(bps) = default(10Mbps); // bits per second; 0=infinite
        
    types:
        channel SlowP extends DatarateChannel
        {
            parameters:
                per = 0;
                ber = 0;
        }
        channel NormalP extends DatarateChannel
        {
            parameters:
                per = 0;
                ber = 0;
        }
        channel HighSpeedP extends DatarateChannel
        {
            parameters:
                per = 0;
                ber = 0;
        }

    submodules:
        configurator: IPv4NetworkConfigurator {
            @display("p=346,30");
        }
        routerIng: SplitTCPRouter {
            parameters:
                @display("p=228,123;i=abstract/router");
        }
        routerEg: SplitTCPRouter {
            parameters:
                @display("p=412,123;i=abstract/router");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=73,38");
        }
        client12: StandardHost2 {
            parameters:
                @display("p=73,100");
        }
        client13: StandardHost2 {
            parameters:
                @display("p=73,158");
        }
        client14: StandardHost2 {
            @display("p=73,220");
        }
        client15: StandardHost2 {
            @display("p=73,284");
        }
        client21: StandardHost2 {
            parameters:
                @display("p=551,38");
        }
        client22: StandardHost2 {
            parameters:
                @display("p=551,100");
        }
        client23: StandardHost2 {
            parameters:
                @display("p=551,158");
        }
        client24: StandardHost2 {
            @display("p=551,220");
        }
        client25: StandardHost2 {
            @display("p=551,284");
        }
    connections:

        routerIng.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client11.pppg++;
        routerIng.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client12.pppg++;
        routerIng.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client13.pppg++;
        routerIng.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client14.pppg++;
        routerIng.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client15.pppg++;

        routerIng.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> routerEg.pppg++;

        routerEg.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client21.pppg++;
        routerEg.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client22.pppg++;
        routerEg.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client23.pppg++;
        routerEg.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client24.pppg++;
        routerEg.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client25.pppg++;
}
