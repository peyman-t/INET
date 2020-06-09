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

        double mdatarate @unit(bps) = default(ldatarate);

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

        routerIng.pppg++ <--> NormalP {  delay = ldelay; datarate = mdatarate; } <--> routerEg.pppg++;

        routerEg.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client21.pppg++;
        routerEg.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client22.pppg++;
        routerEg.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client23.pppg++;
        routerEg.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client24.pppg++;
        routerEg.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client25.pppg++;
}

network chain
{
    parameters:
        @display("bgb=637,337");
        double ldelay @unit(s) = default(0.01s);
        double ldatarate @unit(bps) = default(10Mbps); // bits per second; 0=infinite

        double mdatarate @unit(bps) = default(ldatarate * 0.8);

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
                @display("p=95,123");
        }
        client21: StandardHost2 {
            parameters:
                @display("p=553,123");
        }
    connections:

        routerIng.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client11.pppg++;
        routerIng.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> routerEg.pppg++;

        routerEg.pppg++ <--> NormalP {  delay = ldelay; datarate = mdatarate; } <--> client21.pppg++;
}

network chainLong
{
    parameters:
        @display("bgb=637,337");
        double ldelay @unit(s) = default(0.01s);
        double ldatarate @unit(bps) = default(10Mbps); // bits per second; 0=infinite

        double mdatarate @unit(bps) = default(ldatarate * 0.8);

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
        router1: SplitTCPRouter {
            parameters:
                @display("p=228,123;i=abstract/router");
        }
        router5: SplitTCPRouter {
            parameters:
                @display("p=412,123;i=abstract/router");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=95,123");
        }
        client21: StandardHost2 {
            parameters:
                @display("p=553,123");
        }
        router2: SplitTCPRouter {
            parameters:
                @display("p=228,197;i=abstract/router");
        }
        router3: SplitTCPRouter {
            parameters:
                @display("p=329,197;i=abstract/router");
        }
        router4: SplitTCPRouter {
            parameters:
                @display("p=412,197;i=abstract/router");
        }
    connections:

        router1.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client11.pppg++;
        router1.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> router2.pppg++;
        router2.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> router3.pppg++;
        router3.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> router4.pppg++;
        router4.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> router5.pppg++;
        router5.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client21.pppg++;
}

network chain5
{
    parameters:
        @display("bgb=637,555");
        double ldelay @unit(s) = default(0.01s);
        double ldatarate @unit(bps) = default(10Mbps); // bits per second; 0=infinite

        double mdatarate @unit(bps) = default(ldatarate * 0.8);

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
        routerIng1: SplitTCPRouter {
            parameters:
                @display("p=228,123;i=abstract/router");
        }
        routerEg: SplitTCPRouter {
            parameters:
                @display("p=419,300;i=abstract/router");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=95,123");
        }
        client21: StandardHost2 {
            parameters:
                @display("p=559,300");
        }
        client12: StandardHost2 {
            parameters:
                @display("p=95,205");
        }
        routerIng2: SplitTCPRouter {
            parameters:
                @display("p=228,205;i=abstract/router");
        }
        client13: StandardHost2 {
            parameters:
                @display("p=95,300");
        }
        routerIng3: SplitTCPRouter {
            parameters:
                @display("p=228,300;i=abstract/router");
        }
        client14: StandardHost2 {
            parameters:
                @display("p=95,389");
        }
        routerIng4: SplitTCPRouter {
            parameters:
                @display("p=228,389;i=abstract/router");
        }
        client15: StandardHost2 {
            parameters:
                @display("p=95,473");
        }
        routerIng5: SplitTCPRouter {
            parameters:
                @display("p=228,473;i=abstract/router");
        }
    connections:

        routerIng1.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client11.pppg++;
        routerIng1.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> routerEg.pppg++;

        routerEg.pppg++ <--> NormalP {  delay = ldelay; datarate = mdatarate; } <--> client21.pppg++;
        routerIng2.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client12.pppg++;
        routerIng3.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client13.pppg++;
        routerIng4.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client14.pppg++;
        routerIng5.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> client15.pppg++;
        routerIng2.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> routerEg.pppg++;
        routerIng3.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> routerEg.pppg++;
        routerIng4.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> routerEg.pppg++;
        routerIng5.pppg++ <--> NormalP {  delay = ldelay; datarate = ldatarate; } <--> routerEg.pppg++;
}
