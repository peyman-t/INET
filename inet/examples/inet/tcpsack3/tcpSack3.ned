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

import inet.linklayer.IOutputQueue;
import inet.linklayer.queue.DropTailQueue;
import inet.linklayer.queue.FIFOQueue;
import inet.linklayer.queue.REDDropper;


network ber
{
    parameters:
        @display("bgb=637,253");
        double ldelay @unit(s) = default(0.01s);
    types:
        channel SlowP extends DatarateChannel
        {
            parameters:
                datarate = 1Mbps;
                per = 0;
                ber = 0.00001;
        }
        channel NormalP extends DatarateChannel
        {
            parameters:
                datarate = 1Mbps;
                per = 0;
                ber = 0.00001;
        }
        channel HighSpeedP extends DatarateChannel
        {
            parameters:
                datarate = 1Mbps;
                per = 0;
                ber = 0.00001;
        }

    submodules:
        client1: StandardHost2 {
            parameters:
                @display("p=50,100");
        }
        configurator: IPv4NetworkConfigurator;
        client2: StandardHost2 {
            parameters:
                @display("p=50,200");
        }
    connections:
        client1.pppg++ <--> NormalP {  delay = ldelay; } <--> client2.pppg++;
}

network tcpValidation
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
//        routerIng.pppg++ <--> NormalP{delay = 1ms;} <--> client1.pppg++;
//        routerIng.pppg++ <--> NormalP{delay = 1ms;} <--> client2.pppg++;
//        
//        routerIng.pppg++ <--> HighSpeedP{delay = 1ms;} <--> routerCore.pppg++;
//        routerCore.pppg++ <--> HighSpeedP{delay = 1ms;} <--> routerEg.pppg++;
//
//        routerEg.pppg++ <--> SlowP{delay = ldelay;} <--> client3.pppg++;
//        routerEg.pppg++ <--> NormalP{delay = ldelay;} <--> client4.pppg++;

        routerIng.pppg++ <--> NormalP {  delay = ldelay; } <--> client1.pppg++;
        routerIng.pppg++ <--> NormalP {  delay = ldelay; } <--> client2.pppg++;

        routerIng.pppg++ <--> HighSpeedP {  delay = ldelay; } <--> routerCore.pppg++;
        routerCore.pppg++ <--> HighSpeedP {  delay = ldelay; } <--> routerEg.pppg++;

        routerEg.pppg++ <--> SlowP {  delay = ldelay; } <--> client3.pppg++;
        routerEg.pppg++ <--> NormalP {  delay = ldelay; } <--> client4.pppg++;
}

network tcpValidationTest
{
    parameters:
        @display("bgb=637,253");
        double ldelay @unit(s) = default(0.01s);
    types:
        channel SlowP extends DatarateChannel
        {
            parameters:
                datarate = 20Mbps;
                per = 0;
                ber = 0;
        }
        channel NormalP extends DatarateChannel
        {
            parameters:
                datarate = 100Mbps;
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
        routerIng: SplitTCPRouter {
            parameters:
                @display("p=309,145;i=abstract/router");
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
//        routerIng.pppg++ <--> NormalP{delay = 1ms;} <--> client1.pppg++;
//        routerIng.pppg++ <--> NormalP{delay = 1ms;} <--> client2.pppg++;
//        
//        routerIng.pppg++ <--> HighSpeedP{delay = 1ms;} <--> routerCore.pppg++;
//        routerCore.pppg++ <--> HighSpeedP{delay = 1ms;} <--> routerEg.pppg++;
//
//        routerEg.pppg++ <--> SlowP{delay = ldelay;} <--> client3.pppg++;
//        routerEg.pppg++ <--> NormalP{delay = ldelay;} <--> client4.pppg++;

        routerIng.pppg++ <--> NormalP {  delay = ldelay; } <--> client1.pppg++;
        routerIng.pppg++ <--> NormalP {  delay = ldelay; } <--> client2.pppg++;

        routerIng.pppg++ <--> SlowP {  delay = ldelay; } <--> client3.pppg++;
        routerIng.pppg++ <--> SlowP {  delay = ldelay; } <--> client4.pppg++;
}

network dumbbellAgg
{
    parameters:
        @display("bgb=637,337");
        double ldelay @unit(s) = default(0.1s);
    types:
        channel SlowP extends DatarateChannel
        {
            parameters:
                datarate = 3Mbps;
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

        routerIng.pppg++ <--> NormalP {  delay = ldelay; } <--> client11.pppg++;
        routerIng.pppg++ <--> NormalP {  delay = ldelay; } <--> client12.pppg++;
        routerIng.pppg++ <--> NormalP {  delay = ldelay; } <--> client13.pppg++;
        routerIng.pppg++ <--> NormalP {  delay = ldelay; } <--> client14.pppg++;
        routerIng.pppg++ <--> NormalP {  delay = ldelay; } <--> client15.pppg++;

        routerIng.pppg++ <--> NormalP {  delay = ldelay; } <--> routerEg.pppg++;

        routerEg.pppg++ <--> NormalP {  delay = ldelay; } <--> client21.pppg++;
        routerEg.pppg++ <--> NormalP {  delay = ldelay; } <--> client22.pppg++;
        routerEg.pppg++ <--> NormalP {  delay = ldelay; } <--> client23.pppg++;
        routerEg.pppg++ <--> NormalP {  delay = ldelay; } <--> client24.pppg++;
        routerEg.pppg++ <--> NormalP {  delay = ldelay; } <--> client25.pppg++;
}

network tcpSTCPValidation2
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
        client1: StandardHost2 {
            parameters:
                @display("p=50,100");
        }
        configurator: IPv4NetworkConfigurator;
        client3: StandardHost2 {
            parameters:
                @display("p=581,100");
        }
    connections:
        routerCore.pppg++ <--> NormalP {  delay = ldelay * 3; } <--> client1.pppg++;
        routerCore.pppg++ <--> SlowP {  delay = ldelay; } <--> client3.pppg++;
}

network tcpSTCPValidation
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
        client1: StandardHost2 {
            parameters:
                @display("p=50,100");
        }
        configurator: IPv4NetworkConfigurator;
        client3: StandardHost2 {
            parameters:
                @display("p=581,100");
        }
    connections:
        client3.pppg++ <--> SlowP {  delay = ldelay; } <--> client1.pppg++;
}

network tcpValidation2
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

        routerIng.pppg++ <--> HighSpeedPath <--> routerCore.pppg++;
        routerCore.pppg++ <--> HighSpeedPath <--> routerEg.pppg++;

        routerEg.pppg++ <--> SlowPath <--> client3.pppg++;
        routerEg.pppg++ <--> NormalPath <--> client4.pppg++;
}

network tcpsackFO
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

        routerIng.pppg++ <--> HighSpeedPath <--> routerCore.pppg++;
        routerCore.pppg++ <--> HighSpeedPath <--> routerEg.pppg++;

        routerEg.pppg++ <--> NormalPath <--> client3.pppg++;
        routerEg.pppg++ <--> SlowPath <--> client4.pppg++;
}

network tcpsackPF
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

        routerIng.pppg++ <--> HighSpeedPath <--> routerCore.pppg++;
        routerCore.pppg++ <--> SlowPath <--> routerEg.pppg++;

        routerEg.pppg++ <--> NormalPath <--> client3.pppg++;
        routerEg.pppg++ <--> NormalPath <--> client4.pppg++;
}

network tcpsackFI
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

        routerIng.pppg++ <--> SlowPath <--> routerCore.pppg++;
        routerCore.pppg++ <--> HighSpeedPath <--> routerEg.pppg++;

        routerEg.pppg++ <--> NormalPath <--> client3.pppg++;
        routerEg.pppg++ <--> NormalPath <--> client4.pppg++;
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
