//
// author: Thomas Reschka
//

package inet.examples.inet.DCTCP2;

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
        @display("bgb=740,580");
    //        double ldelay @unit(s) = default(0.1s);
    //        double ldatarate @unit(Mbps) = default(10Mbps);
    types:
        channel NormalP extends DatarateChannel
        {
            parameters:
                //                datarate = ldatarate;
                per = 0;
                ber = 0;
        }


    submodules:
        routerCore: SplitTCPRouter {
            parameters:
                @display("p=315,141;i=abstract/router");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=50,100");
        }
        client12: StandardHost2 {
            parameters:
                @display("p=50,176");
        }
        client13: StandardHost2 {
            parameters:
                @display("p=32,239");
        }
        client14: StandardHost2 {
            parameters:
                @display("p=38,307");
        }
        client15: StandardHost2 {
            parameters:
                @display("p=44,386");
        }
        client16: StandardHost2 {
            parameters:
                @display("p=106,425");
        }
        client17: StandardHost2 {
            parameters:
                @display("p=172,425");
        }
        client18: StandardHost2 {
            parameters:
                @display("p=250,416");
        }
        client19: StandardHost2 {
            parameters:
                @display("p=331,425");
        }
        client110: StandardHost2 {
            parameters:
                @display("p=370,503");
        }
        client111: StandardHost2 {
            parameters:
                @display("p=411,531");
        }
        client112: StandardHost2 {
            parameters:
                @display("p=450,464");
        }
        client113: StandardHost2 {
            parameters:
                @display("p=463,404");
        }
        client114: StandardHost2 {
            parameters:
                @display("p=541,455");
        }
        client115: StandardHost2 {
            parameters:
                @display("p=598,443");
        }
        client116: StandardHost2 {
            parameters:
                @display("p=598,377");
        }
        client117: StandardHost2 {
            parameters:
                @display("p=591,307");
        }
        client118: StandardHost2 {
            parameters:
                @display("p=591,245");
        }
        client119: StandardHost2 {
            parameters:
                @display("p=591,176");
        }
        client120: StandardHost2 {
            parameters:
                @display("p=580,119");
        }
        configurator: IPv4NetworkConfigurator;
        client21: StandardHost2 {
            parameters:
                @display("p=392,38");
        }
    connections:
        routerCore.pppg++ <--> e1: NormalP <--> client11.pppg++;
        routerCore.pppg++ <--> e2: NormalP <--> client12.pppg++;
        routerCore.pppg++ <--> e3: NormalP <--> client13.pppg++;
        routerCore.pppg++ <--> e4: NormalP <--> client14.pppg++;
        routerCore.pppg++ <--> e5: NormalP <--> client15.pppg++;
        routerCore.pppg++ <--> e6: NormalP <--> client16.pppg++;
        routerCore.pppg++ <--> e7: NormalP <--> client17.pppg++;
        routerCore.pppg++ <--> e8: NormalP <--> client18.pppg++;
        routerCore.pppg++ <--> e9: NormalP <--> client19.pppg++;
        routerCore.pppg++ <--> e10: NormalP <--> client110.pppg++;
        routerCore.pppg++ <--> e11: NormalP <--> client111.pppg++;
        routerCore.pppg++ <--> e12: NormalP <--> client112.pppg++;
        routerCore.pppg++ <--> e13: NormalP <--> client113.pppg++;
        routerCore.pppg++ <--> e14: NormalP <--> client114.pppg++;
        routerCore.pppg++ <--> e15: NormalP <--> client115.pppg++;
        routerCore.pppg++ <--> e16: NormalP <--> client116.pppg++;
        routerCore.pppg++ <--> e17: NormalP <--> client117.pppg++;
        routerCore.pppg++ <--> e18: NormalP <--> client118.pppg++;
        routerCore.pppg++ <--> e19: NormalP <--> client119.pppg++;
        routerCore.pppg++ <--> e20: NormalP <--> client120.pppg++;
        routerCore.pppg++ <--> e21: NormalP <--> client21.pppg++;
}

network DCTCPDumbbell
{
    parameters:
        @display("bgb=740,580");
    //        double ldelay @unit(s) = default(0.1s);
    //        double ldatarate @unit(Mbps) = default(10Mbps);
    types:
        channel NormalP extends DatarateChannel
        {
            parameters:
                //                datarate = ldatarate;
                per = 0;
                ber = 0;
        }


    submodules:
        routerCore: SplitTCPRouter {
            parameters:
                @display("p=315,141;i=abstract/router");
        }
        routerCore2: SplitTCPRouter {
            parameters:
                @display("p=437,141;i=abstract/router");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=50,100");
        }
        client12: StandardHost2 {
            parameters:
                @display("p=50,176");
        }
        client13: StandardHost2 {
            parameters:
                @display("p=32,239");
        }
        client14: StandardHost2 {
            parameters:
                @display("p=38,307");
        }
        client15: StandardHost2 {
            parameters:
                @display("p=44,386");
        }
        client16: StandardHost2 {
            parameters:
                @display("p=38,464");
        }
        client17: StandardHost2 {
            parameters:
                @display("p=83,518");
        }
        client18: StandardHost2 {
            parameters:
                @display("p=146,525");
        }
        client19: StandardHost2 {
            parameters:
                @display("p=204,525");
        }
        client110: StandardHost2 {
            parameters:
                @display("p=266,518");
        }
        client21: StandardHost2 {
            parameters:
                @display("p=584,100");
        }
        client22: StandardHost2 {
            parameters:
                @display("p=692,128");
        }
        client23: StandardHost2 {
            parameters:
                @display("p=681,200");
        }
        client24: StandardHost2 {
            parameters:
                @display("p=692,268");
        }
        client25: StandardHost2 {
            parameters:
                @display("p=692,337");
        }
        client26: StandardHost2 {
            parameters:
                @display("p=692,418");
        }
        client27: StandardHost2 {
            parameters:
                @display("p=692,503");
        }
        client28: StandardHost2 {
            parameters:
                @display("p=623,541");
        }
        client29: StandardHost2 {
            parameters:
                @display("p=558,541");
        }
        client210: StandardHost2 {
            parameters:
                @display("p=497,541");
        }
        configurator: IPv4NetworkConfigurator;
    connections:
        routerCore.pppg++ <--> e1: NormalP <--> client11.pppg++;
        routerCore.pppg++ <--> e2: NormalP <--> client12.pppg++;
        routerCore.pppg++ <--> e3: NormalP <--> client13.pppg++;
        routerCore.pppg++ <--> e4: NormalP <--> client14.pppg++;
        routerCore.pppg++ <--> e5: NormalP <--> client15.pppg++;
        routerCore.pppg++ <--> e6: NormalP <--> client16.pppg++;
        routerCore.pppg++ <--> e7: NormalP <--> client17.pppg++;
        routerCore.pppg++ <--> e8: NormalP <--> client18.pppg++;
        routerCore.pppg++ <--> e9: NormalP <--> client19.pppg++;
        routerCore.pppg++ <--> e10: NormalP <--> client110.pppg++;

        routerCore2.pppg++ <--> e11: NormalP <--> client21.pppg++;
        routerCore2.pppg++ <--> e12: NormalP <--> client22.pppg++;
        routerCore2.pppg++ <--> e13: NormalP <--> client23.pppg++;
        routerCore2.pppg++ <--> e14: NormalP <--> client24.pppg++;
        routerCore2.pppg++ <--> e15: NormalP <--> client25.pppg++;
        routerCore2.pppg++ <--> e16: NormalP <--> client26.pppg++;
        routerCore2.pppg++ <--> e17: NormalP <--> client27.pppg++;
        routerCore2.pppg++ <--> e18: NormalP <--> client28.pppg++;
        routerCore2.pppg++ <--> e19: NormalP <--> client29.pppg++;
        routerCore2.pppg++ <--> e20: NormalP <--> client210.pppg++;

        routerCore.pppg++ <--> e21: NormalP <--> routerCore2.pppg++;
}

network DCTCPBitDown3
{
    parameters:
        @display("bgb=940,276");
    //        double ldelay @unit(s) = default(0.1s);
    //        double ldatarate @unit(Mbps) = default(10Mbps);
    types:
        channel NormalP extends DatarateChannel
        {
            parameters:
                //                datarate = ldatarate;
                per = 0;
                ber = 0;
        }


    submodules:
        routerCore: SplitTCPRouter {
            parameters:
                @display("p=179,128;i=abstract/router");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=78,100");
        }
        client12: StandardHost2 {
            parameters:
                @display("p=78,163");
        }
        client23: StandardHost2 {
            parameters:
                @display("p=599,188");
        }
        configurator: IPv4NetworkConfigurator;
        routerCore1: SplitTCPRouter {
            parameters:
                @display("p=345,128;i=abstract/router");
        }
        client22: StandardHost2 {
            parameters:
                @display("p=306,195");
        }
        client13: StandardHost2 {
            parameters:
                @display("p=384,195");
        }
        client21: StandardHost2 {
            parameters:
                @display("p=599,77");
        }
        routerCore3: SplitTCPRouter {
            parameters:
                @display("p=529,128;i=abstract/router");
        }
    connections:
        routerCore.pppg++ <--> e1: NormalP <--> client11.pppg++;
        routerCore.pppg++ <--> e2: NormalP <--> client12.pppg++;
        routerCore.pppg++ <--> e4: NormalP <--> routerCore1.pppg++;
        client22.pppg++ <--> e9: NormalP <--> routerCore1.pppg++;
        client13.pppg++ <--> e10: NormalP <--> routerCore1.pppg++;
        routerCore1.pppg++ <--> e11: NormalP <--> routerCore3.pppg++;
        routerCore3.pppg++ <--> e12: NormalP <--> client21.pppg++;
        client23.pppg++ <--> e13: NormalP <--> routerCore3.pppg++;
}

network DCTCPBitDown
{
    parameters:
        @display("bgb=940,276");
    //        double ldelay @unit(s) = default(0.1s);
    //        double ldatarate @unit(Mbps) = default(10Mbps);
    types:
        channel NormalP extends DatarateChannel
        {
            parameters:
                //                datarate = ldatarate;
                per = 0;
                ber = 0;
        }


    submodules:
        routerCore: SplitTCPRouter {
            parameters:
                @display("p=179,128;i=abstract/router");
        }
        routerCore2: SplitTCPRouter {
            parameters:
                @display("p=531,128;i=abstract/router");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=78,100");
        }
        client12: StandardHost2 {
            parameters:
                @display("p=78,163");
        }
        client23: StandardHost2 {
            parameters:
                @display("p=482,202");
        }
        configurator: IPv4NetworkConfigurator;
        routerCore1: SplitTCPRouter {
            parameters:
                @display("p=345,128;i=abstract/router");
        }
        client22: StandardHost2 {
            parameters:
                @display("p=306,195");
        }
        client13: StandardHost2 {
            parameters:
                @display("p=384,195");
        }
        routerCore3: SplitTCPRouter {
            parameters:
                @display("p=732,128;i=abstract/router");
        }
        client24: StandardHost2 {
            parameters:
                @display("p=825,195");
        }
        client14: StandardHost2 {
            parameters:
                @display("p=599,195");
        }
        client21: StandardHost2 {
            parameters:
                @display("p=825,100");
        }
        client111: StandardHost2 {
            parameters:
                @display("p=78,38");
        }
        client211: StandardHost2 {
            parameters:
                @display("p=825,30");
        }
        client112: StandardHost2 {
            parameters:
                @display("p=345,234");
        }
        client212: StandardHost2 {
            parameters:
                @display("p=540,234");
        }
    connections:
        routerCore.pppg++ <--> e1: NormalP <--> client11.pppg++;
        routerCore.pppg++ <--> e2: NormalP <--> client12.pppg++;
        routerCore2.pppg++ <--> e3: NormalP <--> client23.pppg++;
        routerCore.pppg++ <--> e4: NormalP <--> routerCore1.pppg++;
        routerCore1.pppg++ <--> e5: NormalP <--> routerCore2.pppg++;
        routerCore2.pppg++ <--> e6: NormalP <--> routerCore3.pppg++;
        routerCore3.pppg++ <--> e7: NormalP <--> client24.pppg++;
        routerCore3.pppg++ <--> e8: NormalP <--> client21.pppg++;
        client22.pppg++ <--> e9: NormalP <--> routerCore1.pppg++;
        client13.pppg++ <--> e10: NormalP <--> routerCore1.pppg++;
        client14.pppg++ <--> e11: NormalP <--> routerCore2.pppg++;
        client111.pppg++ <--> e12: NormalP <--> routerCore.pppg++;
        routerCore3.pppg++ <--> e13: NormalP <--> client211.pppg++;
        client112.pppg++ <--> e14: NormalP <--> routerCore1.pppg++;
        client212.pppg++ <--> e15: NormalP <--> routerCore2.pppg++;
}

network DCTCPBitDown5
{
    parameters:
        @display("bgb=1192,276");
    //        double ldelay @unit(s) = default(0.1s);
    //        double ldatarate @unit(Mbps) = default(10Mbps);
    types:
        channel NormalP extends DatarateChannel
        {
            parameters:
                //                datarate = ldatarate;
                per = 0;
                ber = 0;
        }


    submodules:
        routerCore: SplitTCPRouter {
            parameters:
                @display("p=179,128;i=abstract/router");
        }
        routerCore2: SplitTCPRouter {
            parameters:
                @display("p=531,128;i=abstract/router");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=78,100");
        }
        client12: StandardHost2 {
            parameters:
                @display("p=78,163");
        }
        client23: StandardHost2 {
            parameters:
                @display("p=492,195");
        }
        configurator: IPv4NetworkConfigurator;
        routerCore1: SplitTCPRouter {
            parameters:
                @display("p=345,128;i=abstract/router");
        }
        client22: StandardHost2 {
            parameters:
                @display("p=306,195");
        }
        client13: StandardHost2 {
            parameters:
                @display("p=384,195");
        }
        routerCore3: SplitTCPRouter {
            parameters:
                @display("p=732,128;i=abstract/router");
        }
        client24: StandardHost2 {
            parameters:
                @display("p=693,195");
        }
        client14: StandardHost2 {
            parameters:
                @display("p=582,195");
        }
        client21: StandardHost2 {
            parameters:
                @display("p=1039,100");
        }
        routerCore4: SplitTCPRouter {
            parameters:
                @display("p=928,128;i=abstract/router");
        }
        client15: StandardHost2 {
            parameters:
                @display("p=771,195");
        }
        client25: StandardHost2 {
            parameters:
                @display("p=1039,195");
        }
    connections:
        routerCore.pppg++ <--> e1: NormalP <--> client11.pppg++;
        routerCore.pppg++ <--> e2: NormalP <--> client12.pppg++;
        routerCore2.pppg++ <--> e3: NormalP <--> client23.pppg++;
        routerCore.pppg++ <--> e4: NormalP <--> routerCore1.pppg++;
        routerCore1.pppg++ <--> e5: NormalP <--> routerCore2.pppg++;
        routerCore2.pppg++ <--> e6: NormalP <--> routerCore3.pppg++;
        client22.pppg++ <--> e7: NormalP <--> routerCore1.pppg++;
        client13.pppg++ <--> e8: NormalP <--> routerCore1.pppg++;
        client14.pppg++ <--> e9: NormalP <--> routerCore2.pppg++;
        routerCore3.pppg++ <--> e10: NormalP <--> client24.pppg++;
        routerCore4.pppg++ <--> e11: NormalP <--> client21.pppg++;
        routerCore3.pppg++ <--> e12: NormalP <--> routerCore4.pppg++;
        client15.pppg++ <--> e13: NormalP <--> routerCore3.pppg++;
        routerCore4.pppg++ <--> e14: NormalP <--> client25.pppg++;
}

network DCTCPBitDown10
{
    parameters:
        @display("bgb=1192,276");
    //        double ldelay @unit(s) = default(0.1s);
    //        double ldatarate @unit(Mbps) = default(10Mbps);
    types:
        channel NormalP extends DatarateChannel
        {
            parameters:
                //                datarate = ldatarate;
                per = 0;
                ber = 0;
        }


    submodules:
        routerCore: SplitTCPRouter {
            parameters:
                @display("p=144,128;i=abstract/router");
        }
        routerCore2: SplitTCPRouter {
            parameters:
                @display("p=294,128;i=abstract/router");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=63,93");
        }
        client12: StandardHost2 {
            parameters:
                @display("p=150,242");
        }
        client23: StandardHost2 {
            parameters:
                @display("p=268,189");
        }
        configurator: IPv4NetworkConfigurator;
        routerCore1: SplitTCPRouter {
            parameters:
                @display("p=218,128;i=abstract/router");
        }
        client22: StandardHost2 {
            parameters:
                @display("p=199,189");
        }
        client13: StandardHost2 {
            parameters:
                @display("p=238,242");
        }
        routerCore3: SplitTCPRouter {
            parameters:
                @display("p=369,128;i=abstract/router");
        }
        client24: StandardHost2 {
            parameters:
                @display("p=346,189");
        }
        client14: StandardHost2 {
            parameters:
                @display("p=307,242");
        }
        client21: StandardHost2 {
            parameters:
                @display("p=927,100");
        }
        routerCore4: SplitTCPRouter {
            parameters:
                @display("p=442,128;i=abstract/router");
        }
        client15: StandardHost2 {
            parameters:
                @display("p=385,242");
        }
        client25: StandardHost2 {
            parameters:
                @display("p=424,195");
        }
        routerCore5: SplitTCPRouter {
            parameters:
                @display("p=515,128;i=abstract/router");
        }
        routerCore6: SplitTCPRouter {
            parameters:
                @display("p=593,128;i=abstract/router");
        }
        routerCore7: SplitTCPRouter {
            parameters:
                @display("p=674,128;i=abstract/router");
        }
        routerCore8: SplitTCPRouter {
            parameters:
                @display("p=751,128;i=abstract/router");
        }
        routerCore9: SplitTCPRouter {
            parameters:
                @display("p=837,128;i=abstract/router");
        }
        client16: StandardHost2 {
            parameters:
                @display("p=463,242");
        }
        client17: StandardHost2 {
            parameters:
                @display("p=537,242");
        }
        client18: StandardHost2 {
            parameters:
                @display("p=617,242");
        }
        client19: StandardHost2 {
            parameters:
                @display("p=701,242");
        }
        client110: StandardHost2 {
            parameters:
                @display("p=779,242");
        }
        client210: StandardHost2 {
            parameters:
                @display("p=825,195");
        }
        client26: StandardHost2 {
            parameters:
                @display("p=488,195");
        }
        client27: StandardHost2 {
            parameters:
                @display("p=568,195");
        }
        client28: StandardHost2 {
            parameters:
                @display("p=656,195");
        }
        client29: StandardHost2 {
            parameters:
                @display("p=733,195");
        }
    connections:
        routerCore.pppg++ <--> e1: NormalP <--> client11.pppg++;
        routerCore.pppg++ <--> e2: NormalP <--> client12.pppg++;
        routerCore2.pppg++ <--> e3: NormalP <--> client23.pppg++;
        routerCore.pppg++ <--> e4: NormalP <--> routerCore1.pppg++;
        routerCore1.pppg++ <--> e5: NormalP <--> routerCore2.pppg++;
        routerCore2.pppg++ <--> e6: NormalP <--> routerCore3.pppg++;
        client22.pppg++ <--> e7: NormalP <--> routerCore1.pppg++;
        client13.pppg++ <--> e8: NormalP <--> routerCore1.pppg++;
        client14.pppg++ <--> e9: NormalP <--> routerCore2.pppg++;
        routerCore3.pppg++ <--> e10: NormalP <--> client24.pppg++;
        routerCore3.pppg++ <--> e12: NormalP <--> routerCore4.pppg++;
        client15.pppg++ <--> e13: NormalP <--> routerCore3.pppg++;
        routerCore4.pppg++ <--> e14: NormalP <--> client25.pppg++;
        routerCore9.pppg++ <--> e15: NormalP <--> client21.pppg++;
        routerCore4.pppg++ <--> e16: NormalP <--> routerCore5.pppg++;
        routerCore5.pppg++ <--> e17: NormalP <--> routerCore6.pppg++;
        routerCore6.pppg++ <--> e18: NormalP <--> routerCore7.pppg++;
        routerCore7.pppg++ <--> e19: NormalP <--> routerCore8.pppg++;
        routerCore8.pppg++ <--> e20: NormalP <--> routerCore9.pppg++;
        client16.pppg++ <--> e21: NormalP <--> routerCore4.pppg++;
        client17.pppg++ <--> e22: NormalP <--> routerCore5.pppg++;
        client18.pppg++ <--> e23: NormalP <--> routerCore6.pppg++;
        client19.pppg++ <--> e24: NormalP <--> routerCore7.pppg++;
        client110.pppg++ <--> e25: NormalP <--> routerCore8.pppg++;
        client210.pppg++ <--> e26: NormalP <--> routerCore9.pppg++;
        client26.pppg++ <--> e27: NormalP <--> routerCore5.pppg++;
        client27.pppg++ <--> e28: NormalP <--> routerCore6.pppg++;
        client28.pppg++ <--> e29: NormalP <--> routerCore7.pppg++;
        client29.pppg++ <--> e30: NormalP <--> routerCore8.pppg++;
}

network DCTCPClos
{
    parameters:
        @display("bgb=1044,390");
    //        double ldelay @unit(s) = default(0.1s);
    //        double ldatarate @unit(Mbps) = default(10Mbps);
    types:
        channel NormalP extends DatarateChannel
        {
            parameters:
                datarate = 10Gbps;
                per = 0;
                ber = 0;
                delay = 13.33us;
        }


    submodules:
        Pod01: SplitTCPRouter {
            parameters:
                @display("p=99,269;i=abstract/router");
        }
        client01: StandardHost2 {
            parameters:
                @display("p=60,327");
        }
        client02: StandardHost2 {
            parameters:
                @display("p=117,327");
        }
        client03: StandardHost2 {
            parameters:
                @display("p=177,327");
        }
        client04: StandardHost2 {
            parameters:
                @display("p=255,327");
        }
        configurator: IPv4NetworkConfigurator {
            @display("p=976,64");
        }
        Pod03: SplitTCPRouter {
            @display("p=99,219");
        }
        Pod04: SplitTCPRouter {
            @display("p=216,219");
        }
        Pod02: SplitTCPRouter {
            @display("p=216,269");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=303,327");
        }
        client12: StandardHost2 {
            parameters:
                @display("p=355,327");
        }
        client13: StandardHost2 {
            parameters:
                @display("p=408,327");
        }
        client14: StandardHost2 {
            parameters:
                @display("p=473,327");
        }
        Pod11: SplitTCPRouter {
            parameters:
                @display("p=330,269;i=abstract/router");
        }
        Pod13: SplitTCPRouter {
            @display("p=330,219");
        }
        Pod12: SplitTCPRouter {
            @display("p=447,269");
        }
        Pod14: SplitTCPRouter {
            @display("p=447,219");
        }
        client21: StandardHost2 {
            parameters:
                @display("p=530,327");
        }
        client22: StandardHost2 {
            parameters:
                @display("p=595,327");
        }
        client23: StandardHost2 {
            parameters:
                @display("p=647,327");
        }
        client24: StandardHost2 {
            parameters:
                @display("p=708,327");
        }
        Pod21: SplitTCPRouter {
            parameters:
                @display("p=569,269;i=abstract/router");
        }
        Pod22: SplitTCPRouter {
            @display("p=686,269");
        }
        Pod23: SplitTCPRouter {
            @display("p=569,219");
        }
        Pod24: SplitTCPRouter {
            @display("p=686,219");
        }
        client31: StandardHost2 {
            parameters:
                @display("p=757,327");
        }
        client32: StandardHost2 {
            parameters:
                @display("p=816,327");
        }
        client33: StandardHost2 {
            parameters:
                @display("p=867,327");
        }
        client34: StandardHost2 {
            parameters:
                @display("p=945,327");
        }
        Pod31: SplitTCPRouter {
            parameters:
                @display("p=789,269;i=abstract/router");
        }
        Pod32: SplitTCPRouter {
            @display("p=906,269");
        }
        Pod33: SplitTCPRouter {
            @display("p=789,219");
        }
        Pod34: SplitTCPRouter {
            @display("p=906,219");
        }
        Core0: SplitTCPRouter {
            @display("p=216,91");
        }
        Core1: SplitTCPRouter {
            @display("p=408,91");
        }
        Core2: SplitTCPRouter {
            @display("p=608,91");
        }
        Core3: SplitTCPRouter {
            @display("p=789,91");
        }
    connections:
        Pod01.pppg++ <--> NormalP <--> client01.pppg++;
        Pod01.pppg++ <--> NormalP <--> client02.pppg++;
        Pod02.pppg++ <--> NormalP <--> client03.pppg++;
        Pod02.pppg++ <--> NormalP <--> client04.pppg++;
        Pod01.pppg++ <--> NormalP <--> Pod03.pppg++;
        Pod01.pppg++ <--> NormalP <--> Pod04.pppg++;
        Pod02.pppg++ <--> NormalP <--> Pod03.pppg++;
        Pod02.pppg++ <--> NormalP <--> Pod04.pppg++;
        Pod11.pppg++ <--> NormalP <--> Pod14.pppg++;
        Pod12.pppg++ <--> NormalP <--> Pod13.pppg++;
        Pod12.pppg++ <--> NormalP <--> Pod14.pppg++;
        Pod11.pppg++ <--> NormalP <--> client11.pppg++;
        Pod11.pppg++ <--> NormalP <--> client12.pppg++;
        Pod12.pppg++ <--> NormalP <--> client13.pppg++;
        Pod12.pppg++ <--> NormalP <--> client14.pppg++;
        Pod11.pppg++ <--> NormalP <--> Pod13.pppg++;
        Pod22.pppg++ <--> NormalP <--> Pod23.pppg++;
        Pod22.pppg++ <--> NormalP <--> Pod24.pppg++;
        Pod21.pppg++ <--> NormalP <--> Pod24.pppg++;
        Pod21.pppg++ <--> NormalP <--> client21.pppg++;
        Pod21.pppg++ <--> NormalP <--> client22.pppg++;
        Pod22.pppg++ <--> NormalP <--> client23.pppg++;
        Pod22.pppg++ <--> NormalP <--> client24.pppg++;
        Pod21.pppg++ <--> NormalP <--> Pod23.pppg++;
        Pod32.pppg++ <--> NormalP <--> Pod33.pppg++;
        Pod32.pppg++ <--> NormalP <--> Pod34.pppg++;
        Pod31.pppg++ <--> NormalP <--> Pod34.pppg++;
        Pod31.pppg++ <--> NormalP <--> client31.pppg++;
        Pod31.pppg++ <--> NormalP <--> client32.pppg++;
        Pod32.pppg++ <--> NormalP <--> client33.pppg++;
        Pod32.pppg++ <--> NormalP <--> client34.pppg++;
        Pod31.pppg++ <--> NormalP <--> Pod33.pppg++;
        Pod03.pppg++ <--> NormalP <--> Core0.pppg++;
        Pod03.pppg++ <--> NormalP <--> Core1.pppg++;
        Pod04.pppg++ <--> NormalP <--> Core2.pppg++;
        Pod04.pppg++ <--> NormalP <--> Core3.pppg++;
        Pod13.pppg++ <--> NormalP <--> Core0.pppg++;
        Pod13.pppg++ <--> NormalP <--> Core1.pppg++;
        Pod14.pppg++ <--> NormalP <--> Core2.pppg++;
        Pod14.pppg++ <--> NormalP <--> Core3.pppg++;
        Pod23.pppg++ <--> NormalP <--> Core0.pppg++;
        Pod23.pppg++ <--> NormalP <--> Core1.pppg++;
        Pod24.pppg++ <--> NormalP <--> Core2.pppg++;
        Pod24.pppg++ <--> NormalP <--> Core3.pppg++;
        Pod33.pppg++ <--> NormalP <--> Core0.pppg++;
        Pod33.pppg++ <--> NormalP <--> Core1.pppg++;
        Pod34.pppg++ <--> NormalP <--> Core2.pppg++;
        Pod34.pppg++ <--> NormalP <--> Core3.pppg++;
}

network DCTCPClos2
{
    parameters:
        @display("bgb=2020,857");
    //        double ldelay @unit(s) = default(0.1s);
    //        double ldatarate @unit(Mbps) = default(10Mbps);
    types:
        channel NormalP extends DatarateChannel
        {
            parameters:
                datarate = 10Gbps;
                per = 0;
                ber = 0;
                delay = 13.33us;
        }


    submodules:
        Pod01: SplitTCPRouter {
            parameters:
                @display("p=38,456;i=abstract/router");
        }
        client01: StandardHost2 {
            parameters:
                @display("p=33,600");
        }
        client02: StandardHost2 {
            parameters:
                @display("p=90,600");
        }
        client03: StandardHost2 {
            parameters:
                @display("p=150,600");
        }
        client04: StandardHost2 {
            parameters:
                @display("p=216,600");
        }
        configurator: IPv4NetworkConfigurator {
            @display("p=924,116");
        }
        Pod03: SplitTCPRouter {
            @display("p=39,414");
        }
        Pod04: SplitTCPRouter {
            @display("p=150,414");
        }
        Pod02: SplitTCPRouter {
            @display("p=155,456");
        }
        Core0: SplitTCPRouter {
            @display("p=216,268");
        }
        Core1: SplitTCPRouter {
            @display("p=307,268");
        }
        Core2: SplitTCPRouter {
            @display("p=402,268");
        }
        Core3: SplitTCPRouter {
            @display("p=486,268");
        }
        client1: StandardHost2 {
            parameters:
                @display("p=33,650");
        }
        client2: StandardHost2 {
            parameters:
                @display("p=90,650");
        }
        client3: StandardHost2 {
            parameters:
                @display("p=150,650");
        }
        client4: StandardHost2 {
            parameters:
                @display("p=216,650");
        }
        client5: StandardHost2 {
            parameters:
                @display("p=33,707");
        }
        client6: StandardHost2 {
            parameters:
                @display("p=90,707");
        }
        client7: StandardHost2 {
            parameters:
                @display("p=150,707");
        }
        client8: StandardHost2 {
            parameters:
                @display("p=216,707");
        }
        client9: StandardHost2 {
            parameters:
                @display("p=32,760");
        }
        client10: StandardHost2 {
            parameters:
                @display("p=89,760");
        }
        client15: StandardHost2 {
            parameters:
                @display("p=149,760");
        }
        client16: StandardHost2 {
            parameters:
                @display("p=215,760");
        }
        Pod1: SplitTCPRouter {
            parameters:
                @display("p=89,456;i=abstract/router");
        }
        Pod2: SplitTCPRouter {
            @display("p=215,456");
        }
        Pod3: SplitTCPRouter {
            @display("p=90,414");
        }
        Pod4: SplitTCPRouter {
            @display("p=215,414");
        }
        Core4: SplitTCPRouter {
            @display("p=586,268");
        }
        Core5: SplitTCPRouter {
            @display("p=672,268");
        }
        Core6: SplitTCPRouter {
            @display("p=774,268");
        }
        Core7: SplitTCPRouter {
            @display("p=871,268");
        }
        Core8: SplitTCPRouter {
            @display("p=964,268");
        }
        Core9: SplitTCPRouter {
            @display("p=1053,268");
        }
        Core10: SplitTCPRouter {
            @display("p=1148,268");
        }
        Core11: SplitTCPRouter {
            @display("p=1245,268");
        }
        Core12: SplitTCPRouter {
            @display("p=1344,268");
        }
        Core13: SplitTCPRouter {
            @display("p=1435,268");
        }
        Core14: SplitTCPRouter {
            @display("p=1537,268");
        }
        Core15: SplitTCPRouter {
            @display("p=1634,268");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=277,600");
        }
        client12: StandardHost2 {
            parameters:
                @display("p=277,650");
        }
        client13: StandardHost2 {
            parameters:
                @display("p=334,600");
        }
        client14: StandardHost2 {
            parameters:
                @display("p=334,650");
        }
        client17: StandardHost2 {
            parameters:
                @display("p=394,600");
        }
        client18: StandardHost2 {
            parameters:
                @display("p=394,650");
        }
        client19: StandardHost2 {
            parameters:
                @display("p=460,600");
        }
        client20: StandardHost2 {
            parameters:
                @display("p=460,650");
        }
        client21: StandardHost2 {
            parameters:
                @display("p=277,707");
        }
        client22: StandardHost2 {
            parameters:
                @display("p=334,707");
        }
        client23: StandardHost2 {
            parameters:
                @display("p=394,707");
        }
        client24: StandardHost2 {
            parameters:
                @display("p=460,707");
        }
        client25: StandardHost2 {
            parameters:
                @display("p=276,760");
        }
        client26: StandardHost2 {
            parameters:
                @display("p=333,760");
        }
        client27: StandardHost2 {
            parameters:
                @display("p=393,760");
        }
        client28: StandardHost2 {
            parameters:
                @display("p=459,760");
        }
        Pod5: SplitTCPRouter {
            parameters:
                @display("p=282,456;i=abstract/router");
        }
        Pod6: SplitTCPRouter {
            parameters:
                @display("p=333,456;i=abstract/router");
        }
        Pod7: SplitTCPRouter {
            @display("p=399,456");
        }
        Pod8: SplitTCPRouter {
            @display("p=459,456");
        }
        Pod9: SplitTCPRouter {
            @display("p=283,414");
        }
        Pod10: SplitTCPRouter {
            @display("p=334,414");
        }
        Pod11: SplitTCPRouter {
            @display("p=394,414");
        }
        Pod12: SplitTCPRouter {
            @display("p=459,414");
        }
        client29: StandardHost2 {
            parameters:
                @display("p=515,600");
        }
        client30: StandardHost2 {
            parameters:
                @display("p=515,650");
        }
        client31: StandardHost2 {
            parameters:
                @display("p=572,600");
        }
        client32: StandardHost2 {
            parameters:
                @display("p=572,650");
        }
        client33: StandardHost2 {
            parameters:
                @display("p=632,600");
        }
        client34: StandardHost2 {
            parameters:
                @display("p=632,650");
        }
        client35: StandardHost2 {
            parameters:
                @display("p=698,600");
        }
        client36: StandardHost2 {
            parameters:
                @display("p=698,650");
        }
        client37: StandardHost2 {
            parameters:
                @display("p=515,707");
        }
        client38: StandardHost2 {
            parameters:
                @display("p=572,707");
        }
        client39: StandardHost2 {
            parameters:
                @display("p=632,707");
        }
        client40: StandardHost2 {
            parameters:
                @display("p=698,707");
        }
        client41: StandardHost2 {
            parameters:
                @display("p=514,760");
        }
        client42: StandardHost2 {
            parameters:
                @display("p=571,760");
        }
        client43: StandardHost2 {
            parameters:
                @display("p=631,760");
        }
        client44: StandardHost2 {
            parameters:
                @display("p=697,760");
        }
        Pod13: SplitTCPRouter {
            parameters:
                @display("p=520,456;i=abstract/router");
        }
        Pod14: SplitTCPRouter {
            parameters:
                @display("p=571,456;i=abstract/router");
        }
        Pod15: SplitTCPRouter {
            @display("p=637,456");
        }
        Pod16: SplitTCPRouter {
            @display("p=697,456");
        }
        Pod17: SplitTCPRouter {
            @display("p=521,414");
        }
        Pod18: SplitTCPRouter {
            @display("p=572,414");
        }
        Pod19: SplitTCPRouter {
            @display("p=632,414");
        }
        Pod20: SplitTCPRouter {
            @display("p=697,414");
        }
        client45: StandardHost2 {
            parameters:
                @display("p=749,600");
        }
        client46: StandardHost2 {
            parameters:
                @display("p=749,650");
        }
        client47: StandardHost2 {
            parameters:
                @display("p=806,600");
        }
        client48: StandardHost2 {
            parameters:
                @display("p=806,650");
        }
        client49: StandardHost2 {
            parameters:
                @display("p=866,600");
        }
        client50: StandardHost2 {
            parameters:
                @display("p=866,650");
        }
        client51: StandardHost2 {
            parameters:
                @display("p=932,600");
        }
        client52: StandardHost2 {
            parameters:
                @display("p=932,650");
        }
        client53: StandardHost2 {
            parameters:
                @display("p=749,707");
        }
        client54: StandardHost2 {
            parameters:
                @display("p=806,707");
        }
        client55: StandardHost2 {
            parameters:
                @display("p=866,707");
        }
        client56: StandardHost2 {
            parameters:
                @display("p=932,707");
        }
        client57: StandardHost2 {
            parameters:
                @display("p=748,760");
        }
        client58: StandardHost2 {
            parameters:
                @display("p=805,760");
        }
        client59: StandardHost2 {
            parameters:
                @display("p=865,760");
        }
        client60: StandardHost2 {
            parameters:
                @display("p=931,760");
        }
        Pod21: SplitTCPRouter {
            parameters:
                @display("p=754,456;i=abstract/router");
        }
        Pod22: SplitTCPRouter {
            parameters:
                @display("p=805,456;i=abstract/router");
        }
        Pod23: SplitTCPRouter {
            @display("p=871,456");
        }
        Pod24: SplitTCPRouter {
            @display("p=931,456");
        }
        Pod25: SplitTCPRouter {
            @display("p=755,414");
        }
        Pod26: SplitTCPRouter {
            @display("p=806,414");
        }
        Pod27: SplitTCPRouter {
            @display("p=866,414");
        }
        Pod28: SplitTCPRouter {
            @display("p=931,414");
        }
        client61: StandardHost2 {
            parameters:
                @display("p=1015,600");
        }
        client62: StandardHost2 {
            parameters:
                @display("p=1015,650");
        }
        client63: StandardHost2 {
            parameters:
                @display("p=1072,600");
        }
        client64: StandardHost2 {
            parameters:
                @display("p=1072,650");
        }
        client65: StandardHost2 {
            parameters:
                @display("p=1132,600");
        }
        client66: StandardHost2 {
            parameters:
                @display("p=1132,650");
        }
        client67: StandardHost2 {
            parameters:
                @display("p=1198,600");
        }
        client68: StandardHost2 {
            parameters:
                @display("p=1198,650");
        }
        client69: StandardHost2 {
            parameters:
                @display("p=1015,707");
        }
        client70: StandardHost2 {
            parameters:
                @display("p=1072,707");
        }
        client71: StandardHost2 {
            parameters:
                @display("p=1132,707");
        }
        client72: StandardHost2 {
            parameters:
                @display("p=1198,707");
        }
        client73: StandardHost2 {
            parameters:
                @display("p=1014,760");
        }
        client74: StandardHost2 {
            parameters:
                @display("p=1071,760");
        }
        client75: StandardHost2 {
            parameters:
                @display("p=1259,600");
        }
        client76: StandardHost2 {
            parameters:
                @display("p=1259,650");
        }
        client77: StandardHost2 {
            parameters:
                @display("p=1316,600");
        }
        client78: StandardHost2 {
            parameters:
                @display("p=1316,650");
        }
        client79: StandardHost2 {
            parameters:
                @display("p=1131,760");
        }
        client80: StandardHost2 {
            parameters:
                @display("p=1197,760");
        }
        client81: StandardHost2 {
            parameters:
                @display("p=1376,600");
        }
        client82: StandardHost2 {
            parameters:
                @display("p=1376,650");
        }
        client83: StandardHost2 {
            parameters:
                @display("p=1442,600");
        }
        client84: StandardHost2 {
            parameters:
                @display("p=1442,650");
        }
        client85: StandardHost2 {
            parameters:
                @display("p=1259,707");
        }
        client86: StandardHost2 {
            parameters:
                @display("p=1316,707");
        }
        client87: StandardHost2 {
            parameters:
                @display("p=1376,707");
        }
        client88: StandardHost2 {
            parameters:
                @display("p=1442,707");
        }
        client89: StandardHost2 {
            parameters:
                @display("p=1258,760");
        }
        client90: StandardHost2 {
            parameters:
                @display("p=1315,760");
        }
        client91: StandardHost2 {
            parameters:
                @display("p=1375,760");
        }
        client92: StandardHost2 {
            parameters:
                @display("p=1441,760");
        }
        client93: StandardHost2 {
            parameters:
                @display("p=1497,600");
        }
        client94: StandardHost2 {
            parameters:
                @display("p=1497,650");
        }
        client95: StandardHost2 {
            parameters:
                @display("p=1554,600");
        }
        client96: StandardHost2 {
            parameters:
                @display("p=1554,650");
        }
        client97: StandardHost2 {
            parameters:
                @display("p=1614,600");
        }
        client98: StandardHost2 {
            parameters:
                @display("p=1614,650");
        }
        client99: StandardHost2 {
            parameters:
                @display("p=1680,600");
        }
        client100: StandardHost2 {
            parameters:
                @display("p=1680,650");
        }
        client101: StandardHost2 {
            parameters:
                @display("p=1497,707");
        }
        client102: StandardHost2 {
            parameters:
                @display("p=1554,707");
        }
        client103: StandardHost2 {
            parameters:
                @display("p=1614,707");
        }
        client104: StandardHost2 {
            parameters:
                @display("p=1680,707");
        }
        client105: StandardHost2 {
            parameters:
                @display("p=1496,760");
        }
        client106: StandardHost2 {
            parameters:
                @display("p=1553,760");
        }
        client107: StandardHost2 {
            parameters:
                @display("p=1613,760");
        }
        client108: StandardHost2 {
            parameters:
                @display("p=1679,760");
        }
        client109: StandardHost2 {
            parameters:
                @display("p=1731,600");
        }
        client110: StandardHost2 {
            parameters:
                @display("p=1731,650");
        }
        client111: StandardHost2 {
            parameters:
                @display("p=1788,600");
        }
        client112: StandardHost2 {
            parameters:
                @display("p=1788,650");
        }
        client113: StandardHost2 {
            parameters:
                @display("p=1848,600");
        }
        client114: StandardHost2 {
            parameters:
                @display("p=1848,650");
        }
        client115: StandardHost2 {
            parameters:
                @display("p=1914,600");
        }
        client116: StandardHost2 {
            parameters:
                @display("p=1914,650");
        }
        client117: StandardHost2 {
            parameters:
                @display("p=1731,707");
        }
        client118: StandardHost2 {
            parameters:
                @display("p=1788,707");
        }
        client119: StandardHost2 {
            parameters:
                @display("p=1848,707");
        }
        client120: StandardHost2 {
            parameters:
                @display("p=1914,707");
        }
        client121: StandardHost2 {
            parameters:
                @display("p=1730,760");
        }
        client122: StandardHost2 {
            parameters:
                @display("p=1787,760");
        }
        client123: StandardHost2 {
            parameters:
                @display("p=1847,760");
        }
        client124: StandardHost2 {
            parameters:
                @display("p=1913,760");
        }
        Pod29: SplitTCPRouter {
            parameters:
                @display("p=1020,456;i=abstract/router");
        }
        Pod30: SplitTCPRouter {
            parameters:
                @display("p=1071,456;i=abstract/router");
        }
        Pod31: SplitTCPRouter {
            @display("p=1137,456");
        }
        Pod32: SplitTCPRouter {
            @display("p=1197,456");
        }
        Pod33: SplitTCPRouter {
            @display("p=1021,414");
        }
        Pod34: SplitTCPRouter {
            @display("p=1072,414");
        }
        Pod35: SplitTCPRouter {
            @display("p=1132,414");
        }
        Pod36: SplitTCPRouter {
            @display("p=1197,414");
        }
        Pod37: SplitTCPRouter {
            parameters:
                @display("p=1264,456;i=abstract/router");
        }
        Pod38: SplitTCPRouter {
            parameters:
                @display("p=1315,456;i=abstract/router");
        }
        Pod39: SplitTCPRouter {
            @display("p=1381,456");
        }
        Pod40: SplitTCPRouter {
            @display("p=1441,456");
        }
        Pod41: SplitTCPRouter {
            @display("p=1265,414");
        }
        Pod42: SplitTCPRouter {
            @display("p=1316,414");
        }
        Pod43: SplitTCPRouter {
            @display("p=1376,414");
        }
        Pod44: SplitTCPRouter {
            @display("p=1441,414");
        }
        Pod45: SplitTCPRouter {
            parameters:
                @display("p=1502,456;i=abstract/router");
        }
        Pod46: SplitTCPRouter {
            parameters:
                @display("p=1553,456;i=abstract/router");
        }
        Pod47: SplitTCPRouter {
            @display("p=1619,456");
        }
        Pod48: SplitTCPRouter {
            @display("p=1679,456");
        }
        Pod49: SplitTCPRouter {
            @display("p=1503,414");
        }
        Pod50: SplitTCPRouter {
            @display("p=1554,414");
        }
        Pod51: SplitTCPRouter {
            @display("p=1614,414");
        }
        Pod52: SplitTCPRouter {
            @display("p=1679,414");
        }
        Pod53: SplitTCPRouter {
            parameters:
                @display("p=1736,456;i=abstract/router");
        }
        Pod54: SplitTCPRouter {
            parameters:
                @display("p=1787,456;i=abstract/router");
        }
        Pod55: SplitTCPRouter {
            @display("p=1853,456");
        }
        Pod56: SplitTCPRouter {
            @display("p=1913,456");
        }
        Pod57: SplitTCPRouter {
            @display("p=1737,414");
        }
        Pod58: SplitTCPRouter {
            @display("p=1788,414");
        }
        Pod59: SplitTCPRouter {
            @display("p=1848,414");
        }
        Pod60: SplitTCPRouter {
            @display("p=1913,414");
        }
    connections:
        Pod01.pppg++ <--> NormalP <--> client02.pppg++;
        Pod01.pppg++ <--> NormalP <--> Pod03.pppg++;
        Pod01.pppg++ <--> NormalP <--> Pod04.pppg++;
        Pod02.pppg++ <--> NormalP <--> Pod03.pppg++;
        Pod02.pppg++ <--> NormalP <--> Pod04.pppg++;
        Pod01.pppg++ <--> Pod3.pppg++;
        Pod01.pppg++ <--> Pod4.pppg++;
        Pod1.pppg++ <--> Pod03.pppg++;
        Pod1.pppg++ <--> Pod3.pppg++;
        Pod1.pppg++ <--> Pod04.pppg++;
        Pod1.pppg++ <--> Pod4.pppg++;
        Pod02.pppg++ <--> Pod3.pppg++;
        Pod02.pppg++ <--> Pod4.pppg++;
        Pod2.pppg++ <--> Pod4.pppg++;
        Pod2.pppg++ <--> Pod04.pppg++;
        Pod2.pppg++ <--> Pod3.pppg++;
        Pod2.pppg++ <--> Pod03.pppg++;
        client01.pppg++ <--> Pod01.pppg++;
        client03.pppg++ <--> Pod01.pppg++;
        client04.pppg++ <--> Pod01.pppg++;
        client1.pppg++ <--> Pod1.pppg++;
        client2.pppg++ <--> Pod1.pppg++;
        client3.pppg++ <--> Pod1.pppg++;
        client4.pppg++ <--> Pod1.pppg++;
        client5.pppg++ <--> Pod02.pppg++;
        client6.pppg++ <--> Pod02.pppg++;
        client7.pppg++ <--> Pod02.pppg++;
        client8.pppg++ <--> Pod02.pppg++;
        client9.pppg++ <--> Pod2.pppg++;
        client10.pppg++ <--> Pod2.pppg++;
        client15.pppg++ <--> Pod2.pppg++;
        client16.pppg++ <--> Pod2.pppg++;
        Pod03.pppg++ <--> Core0.pppg++;
        Pod03.pppg++ <--> Core1.pppg++;
        Pod03.pppg++ <--> Core2.pppg++;
        Pod03.pppg++ <--> Core3.pppg++;
        Pod3.pppg++ <--> Core4.pppg++;
        Pod3.pppg++ <--> Core5.pppg++;
        Pod3.pppg++ <--> Core6.pppg++;
        Pod3.pppg++ <--> Core7.pppg++;
        Pod04.pppg++ <--> Core8.pppg++;
        Pod04.pppg++ <--> Core9.pppg++;
        Pod04.pppg++ <--> Core10.pppg++;
        Pod04.pppg++ <--> Core11.pppg++;
        Pod4.pppg++ <--> Core12.pppg++;
        Pod4.pppg++ <--> Core13.pppg++;
        Pod4.pppg++ <--> Core14.pppg++;
        Pod4.pppg++ <--> Core15.pppg++;
        Pod5.pppg++ <--> NormalP <--> client13.pppg++;
        Pod5.pppg++ <--> NormalP <--> Pod9.pppg++;
        Pod5.pppg++ <--> NormalP <--> Pod11.pppg++;
        Pod7.pppg++ <--> NormalP <--> Pod9.pppg++;
        Pod7.pppg++ <--> NormalP <--> Pod11.pppg++;
        client25.pppg++ <--> Pod8.pppg++;
        client11.pppg++ <--> Pod5.pppg++;
        client12.pppg++ <--> Pod6.pppg++;
        client24.pppg++ <--> Pod7.pppg++;
        client18.pppg++ <--> Pod6.pppg++;
        Pod8.pppg++ <--> Pod12.pppg++;
        Pod8.pppg++ <--> Pod11.pppg++;
        Pod8.pppg++ <--> Pod10.pppg++;
        Pod8.pppg++ <--> Pod9.pppg++;
        client14.pppg++ <--> Pod6.pppg++;
        client27.pppg++ <--> Pod8.pppg++;
        client21.pppg++ <--> Pod7.pppg++;
        client26.pppg++ <--> Pod8.pppg++;
        client19.pppg++ <--> Pod5.pppg++;
        client28.pppg++ <--> Pod8.pppg++;
        client17.pppg++ <--> Pod5.pppg++;
        client22.pppg++ <--> Pod7.pppg++;
        client20.pppg++ <--> Pod6.pppg++;
        Pod6.pppg++ <--> Pod9.pppg++;
        Pod6.pppg++ <--> Pod10.pppg++;
        Pod6.pppg++ <--> Pod11.pppg++;
        Pod6.pppg++ <--> Pod12.pppg++;
        Pod5.pppg++ <--> Pod10.pppg++;
        Pod5.pppg++ <--> Pod12.pppg++;
        Pod7.pppg++ <--> Pod10.pppg++;
        Pod7.pppg++ <--> Pod12.pppg++;
        client23.pppg++ <--> Pod7.pppg++;
        Pod9.pppg++ <--> Core0.pppg++;
        Pod9.pppg++ <--> Core1.pppg++;
        Pod9.pppg++ <--> Core2.pppg++;
        Pod9.pppg++ <--> Core3.pppg++;
        Pod10.pppg++ <--> Core4.pppg++;
        Pod10.pppg++ <--> Core5.pppg++;
        Pod10.pppg++ <--> Core6.pppg++;
        Pod10.pppg++ <--> Core7.pppg++;
        Pod11.pppg++ <--> Core8.pppg++;
        Pod11.pppg++ <--> Core9.pppg++;
        Pod11.pppg++ <--> Core10.pppg++;
        Pod11.pppg++ <--> Core11.pppg++;
        Pod12.pppg++ <--> Core12.pppg++;
        Pod12.pppg++ <--> Core13.pppg++;
        Pod12.pppg++ <--> Core14.pppg++;
        Pod12.pppg++ <--> Core15.pppg++;
        Pod13.pppg++ <--> NormalP <--> client31.pppg++;
        Pod13.pppg++ <--> NormalP <--> Pod17.pppg++;
        Pod13.pppg++ <--> NormalP <--> Pod19.pppg++;
        Pod15.pppg++ <--> NormalP <--> Pod17.pppg++;
        Pod15.pppg++ <--> NormalP <--> Pod19.pppg++;
        client32.pppg++ <--> Pod14.pppg++;
        client35.pppg++ <--> Pod13.pppg++;
        client38.pppg++ <--> Pod15.pppg++;
        Pod14.pppg++ <--> Pod17.pppg++;
        Pod14.pppg++ <--> Pod18.pppg++;
        Pod14.pppg++ <--> Pod19.pppg++;
        Pod14.pppg++ <--> Pod20.pppg++;
        Pod13.pppg++ <--> Pod18.pppg++;
        Pod13.pppg++ <--> Pod20.pppg++;
        client29.pppg++ <--> Pod13.pppg++;
        client34.pppg++ <--> Pod14.pppg++;
        client40.pppg++ <--> Pod15.pppg++;
        client39.pppg++ <--> Pod15.pppg++;
        client30.pppg++ <--> Pod14.pppg++;
        client36.pppg++ <--> Pod14.pppg++;
        Pod15.pppg++ <--> Pod18.pppg++;
        Pod15.pppg++ <--> Pod20.pppg++;
        client43.pppg++ <--> Pod16.pppg++;
        client44.pppg++ <--> Pod16.pppg++;
        Pod16.pppg++ <--> Pod20.pppg++;
        Pod16.pppg++ <--> Pod19.pppg++;
        Pod16.pppg++ <--> Pod18.pppg++;
        Pod16.pppg++ <--> Pod17.pppg++;
        client42.pppg++ <--> Pod16.pppg++;
        client41.pppg++ <--> Pod16.pppg++;
        client37.pppg++ <--> Pod15.pppg++;
        client33.pppg++ <--> Pod13.pppg++;
        Pod17.pppg++ <--> Core0.pppg++;
        Pod17.pppg++ <--> Core1.pppg++;
        Pod17.pppg++ <--> Core2.pppg++;
        Pod17.pppg++ <--> Core3.pppg++;
        Pod18.pppg++ <--> Core4.pppg++;
        Pod18.pppg++ <--> Core5.pppg++;
        Pod18.pppg++ <--> Core6.pppg++;
        Pod18.pppg++ <--> Core7.pppg++;
        Pod19.pppg++ <--> Core8.pppg++;
        Pod19.pppg++ <--> Core9.pppg++;
        Pod19.pppg++ <--> Core10.pppg++;
        Pod19.pppg++ <--> Core11.pppg++;
        Pod20.pppg++ <--> Core12.pppg++;
        Pod20.pppg++ <--> Core13.pppg++;
        Pod20.pppg++ <--> Core14.pppg++;
        Pod20.pppg++ <--> Core15.pppg++;
        Pod23.pppg++ <--> NormalP <--> Pod25.pppg++;
        Pod23.pppg++ <--> NormalP <--> Pod27.pppg++;
        Pod21.pppg++ <--> NormalP <--> client47.pppg++;
        Pod21.pppg++ <--> NormalP <--> Pod25.pppg++;
        Pod21.pppg++ <--> NormalP <--> Pod27.pppg++;
        client53.pppg++ <--> Pod23.pppg++;
        client58.pppg++ <--> Pod24.pppg++;
        client57.pppg++ <--> Pod24.pppg++;
        client45.pppg++ <--> Pod21.pppg++;
        client46.pppg++ <--> Pod22.pppg++;
        Pod23.pppg++ <--> Pod26.pppg++;
        Pod23.pppg++ <--> Pod28.pppg++;
        client55.pppg++ <--> Pod23.pppg++;
        client49.pppg++ <--> Pod21.pppg++;
        Pod22.pppg++ <--> Pod25.pppg++;
        Pod22.pppg++ <--> Pod26.pppg++;
        Pod22.pppg++ <--> Pod27.pppg++;
        Pod22.pppg++ <--> Pod28.pppg++;
        client54.pppg++ <--> Pod23.pppg++;
        client59.pppg++ <--> Pod24.pppg++;
        client56.pppg++ <--> Pod23.pppg++;
        client51.pppg++ <--> Pod21.pppg++;
        Pod21.pppg++ <--> Pod26.pppg++;
        Pod21.pppg++ <--> Pod28.pppg++;
        client52.pppg++ <--> Pod22.pppg++;
        client60.pppg++ <--> Pod24.pppg++;
        client50.pppg++ <--> Pod22.pppg++;
        client48.pppg++ <--> Pod22.pppg++;
        Pod24.pppg++ <--> Pod28.pppg++;
        Pod24.pppg++ <--> Pod27.pppg++;
        Pod24.pppg++ <--> Pod26.pppg++;
        Pod24.pppg++ <--> Pod25.pppg++;
        Pod25.pppg++ <--> Core0.pppg++;
        Pod25.pppg++ <--> Core1.pppg++;
        Pod25.pppg++ <--> Core2.pppg++;
        Pod25.pppg++ <--> Core3.pppg++;
        Pod26.pppg++ <--> Core4.pppg++;
        Pod26.pppg++ <--> Core5.pppg++;
        Pod26.pppg++ <--> Core6.pppg++;
        Pod26.pppg++ <--> Core7.pppg++;
        Pod27.pppg++ <--> Core8.pppg++;
        Pod27.pppg++ <--> Core9.pppg++;
        Pod27.pppg++ <--> Core10.pppg++;
        Pod27.pppg++ <--> Core11.pppg++;
        Pod28.pppg++ <--> Core12.pppg++;
        Pod28.pppg++ <--> Core13.pppg++;
        Pod28.pppg++ <--> Core14.pppg++;
        Pod28.pppg++ <--> Core15.pppg++;
        Pod29.pppg++ <--> NormalP <--> client63.pppg++;
        Pod29.pppg++ <--> NormalP <--> Pod33.pppg++;
        Pod29.pppg++ <--> NormalP <--> Pod35.pppg++;
        Pod31.pppg++ <--> NormalP <--> Pod33.pppg++;
        Pod31.pppg++ <--> NormalP <--> Pod35.pppg++;
        Pod55.pppg++ <--> NormalP <--> Pod57.pppg++;
        Pod55.pppg++ <--> NormalP <--> Pod59.pppg++;
        Pod37.pppg++ <--> NormalP <--> client77.pppg++;
        Pod37.pppg++ <--> NormalP <--> Pod41.pppg++;
        Pod37.pppg++ <--> NormalP <--> Pod43.pppg++;
        Pod39.pppg++ <--> NormalP <--> Pod41.pppg++;
        Pod39.pppg++ <--> NormalP <--> Pod43.pppg++;
        Pod53.pppg++ <--> NormalP <--> client111.pppg++;
        Pod53.pppg++ <--> NormalP <--> Pod57.pppg++;
        Pod53.pppg++ <--> NormalP <--> Pod59.pppg++;
        Pod47.pppg++ <--> NormalP <--> Pod49.pppg++;
        Pod47.pppg++ <--> NormalP <--> Pod51.pppg++;
        Pod45.pppg++ <--> NormalP <--> client95.pppg++;
        Pod45.pppg++ <--> NormalP <--> Pod49.pppg++;
        Pod45.pppg++ <--> NormalP <--> Pod51.pppg++;
        client78.pppg++ <--> Pod38.pppg++;
        client62.pppg++ <--> Pod30.pppg++;
        client113.pppg++ <--> Pod53.pppg++;
        client72.pppg++ <--> Pod31.pppg++;
        Pod32.pppg++ <--> Pod36.pppg++;
        Pod32.pppg++ <--> Pod35.pppg++;
        Pod32.pppg++ <--> Pod34.pppg++;
        Pod32.pppg++ <--> Pod33.pppg++;
        client64.pppg++ <--> Pod30.pppg++;
        client82.pppg++ <--> Pod38.pppg++;
        client87.pppg++ <--> Pod39.pppg++;
        client74.pppg++ <--> Pod32.pppg++;
        client76.pppg++ <--> Pod38.pppg++;
        client107.pppg++ <--> Pod48.pppg++;
        client67.pppg++ <--> Pod29.pppg++;
        client104.pppg++ <--> Pod47.pppg++;
        client99.pppg++ <--> Pod45.pppg++;
        client115.pppg++ <--> Pod53.pppg++;
        client100.pppg++ <--> Pod46.pppg++;
        client92.pppg++ <--> Pod40.pppg++;
        client124.pppg++ <--> Pod56.pppg++;
        Pod56.pppg++ <--> Pod60.pppg++;
        Pod56.pppg++ <--> Pod59.pppg++;
        Pod56.pppg++ <--> Pod58.pppg++;
        Pod56.pppg++ <--> Pod57.pppg++;
        client109.pppg++ <--> Pod53.pppg++;
        client90.pppg++ <--> Pod40.pppg++;
        client108.pppg++ <--> Pod48.pppg++;
        Pod29.pppg++ <--> Pod34.pppg++;
        Pod29.pppg++ <--> Pod36.pppg++;
        client89.pppg++ <--> Pod40.pppg++;
        client85.pppg++ <--> Pod39.pppg++;
        Pod31.pppg++ <--> Pod34.pppg++;
        Pod31.pppg++ <--> Pod36.pppg++;
        client119.pppg++ <--> Pod55.pppg++;
        Pod55.pppg++ <--> Pod58.pppg++;
        Pod55.pppg++ <--> Pod60.pppg++;
        Pod38.pppg++ <--> Pod41.pppg++;
        Pod38.pppg++ <--> Pod42.pppg++;
        Pod38.pppg++ <--> Pod43.pppg++;
        Pod38.pppg++ <--> Pod44.pppg++;
        client66.pppg++ <--> Pod30.pppg++;
        client94.pppg++ <--> Pod46.pppg++;
        client102.pppg++ <--> Pod47.pppg++;
        client79.pppg++ <--> Pod32.pppg++;
        client91.pppg++ <--> Pod40.pppg++;
        client114.pppg++ <--> Pod54.pppg++;
        Pod54.pppg++ <--> Pod57.pppg++;
        Pod54.pppg++ <--> Pod58.pppg++;
        Pod54.pppg++ <--> Pod59.pppg++;
        Pod54.pppg++ <--> Pod60.pppg++;
        client122.pppg++ <--> Pod56.pppg++;
        Pod30.pppg++ <--> Pod33.pppg++;
        Pod30.pppg++ <--> Pod34.pppg++;
        Pod30.pppg++ <--> Pod35.pppg++;
        Pod30.pppg++ <--> Pod36.pppg++;
        client71.pppg++ <--> Pod31.pppg++;
        client110.pppg++ <--> Pod54.pppg++;
        client101.pppg++ <--> Pod47.pppg++;
        client61.pppg++ <--> Pod29.pppg++;
        client86.pppg++ <--> Pod39.pppg++;
        client105.pppg++ <--> Pod48.pppg++;
        Pod37.pppg++ <--> Pod42.pppg++;
        Pod37.pppg++ <--> Pod44.pppg++;
        client112.pppg++ <--> Pod54.pppg++;
        client103.pppg++ <--> Pod47.pppg++;
        Pod39.pppg++ <--> Pod42.pppg++;
        Pod39.pppg++ <--> Pod44.pppg++;
        client70.pppg++ <--> Pod31.pppg++;
        client118.pppg++ <--> Pod55.pppg++;
        client120.pppg++ <--> Pod55.pppg++;
        client98.pppg++ <--> Pod46.pppg++;
        client96.pppg++ <--> Pod46.pppg++;
        Pod48.pppg++ <--> Pod52.pppg++;
        Pod48.pppg++ <--> Pod51.pppg++;
        Pod48.pppg++ <--> Pod50.pppg++;
        Pod48.pppg++ <--> Pod49.pppg++;
        client121.pppg++ <--> Pod56.pppg++;
        client83.pppg++ <--> Pod37.pppg++;
        client123.pppg++ <--> Pod56.pppg++;
        client73.pppg++ <--> Pod32.pppg++;
        client106.pppg++ <--> Pod48.pppg++;
        Pod53.pppg++ <--> Pod58.pppg++;
        Pod53.pppg++ <--> Pod60.pppg++;
        client93.pppg++ <--> Pod45.pppg++;
        client97.pppg++ <--> Pod45.pppg++;
        Pod47.pppg++ <--> Pod50.pppg++;
        Pod47.pppg++ <--> Pod52.pppg++;
        client75.pppg++ <--> Pod37.pppg++;
        client116.pppg++ <--> Pod54.pppg++;
        Pod46.pppg++ <--> Pod49.pppg++;
        Pod46.pppg++ <--> Pod50.pppg++;
        Pod46.pppg++ <--> Pod51.pppg++;
        Pod46.pppg++ <--> Pod52.pppg++;
        client88.pppg++ <--> Pod39.pppg++;
        client69.pppg++ <--> Pod31.pppg++;
        client117.pppg++ <--> Pod55.pppg++;
        client84.pppg++ <--> Pod38.pppg++;
        client80.pppg++ <--> Pod32.pppg++;
        client65.pppg++ <--> Pod29.pppg++;
        Pod45.pppg++ <--> Pod50.pppg++;
        Pod45.pppg++ <--> Pod52.pppg++;
        Pod40.pppg++ <--> Pod44.pppg++;
        Pod40.pppg++ <--> Pod43.pppg++;
        Pod40.pppg++ <--> Pod42.pppg++;
        Pod40.pppg++ <--> Pod41.pppg++;
        client68.pppg++ <--> Pod30.pppg++;
        client81.pppg++ <--> Pod37.pppg++;
        Pod33.pppg++ <--> Core0.pppg++;
        Pod33.pppg++ <--> Core1.pppg++;
        Pod33.pppg++ <--> Core2.pppg++;
        Pod33.pppg++ <--> Core3.pppg++;
        Pod34.pppg++ <--> Core4.pppg++;
        Pod34.pppg++ <--> Core5.pppg++;
        Pod34.pppg++ <--> Core6.pppg++;
        Pod34.pppg++ <--> Core7.pppg++;
        Pod35.pppg++ <--> Core8.pppg++;
        Pod35.pppg++ <--> Core9.pppg++;
        Pod35.ethg++ <--> Core10.ethg++;
        Pod35.pppg++ <--> Core11.pppg++;
        Pod36.pppg++ <--> Core12.pppg++;
        Pod36.pppg++ <--> Core13.pppg++;
        Pod36.pppg++ <--> Core14.pppg++;
        Pod36.pppg++ <--> Core15.pppg++;
        Pod41.pppg++ <--> Core0.pppg++;
        Pod41.pppg++ <--> Core1.pppg++;
        Pod41.pppg++ <--> Core2.pppg++;
        Pod41.pppg++ <--> Core3.pppg++;
        Pod42.pppg++ <--> Core4.pppg++;
        Pod42.pppg++ <--> Core5.pppg++;
        Pod42.pppg++ <--> Core6.pppg++;
        Pod42.pppg++ <--> Core7.pppg++;
        Pod43.pppg++ <--> Core8.pppg++;
        Pod43.pppg++ <--> Core9.pppg++;
        Pod43.pppg++ <--> Core10.pppg++;
        Pod43.pppg++ <--> Core11.pppg++;
        Pod44.pppg++ <--> Core12.pppg++;
        Pod44.pppg++ <--> Core13.pppg++;
        Pod44.pppg++ <--> Core14.pppg++;
        Pod44.pppg++ <--> Core15.pppg++;
        Pod49.pppg++ <--> Core0.pppg++;
        Pod49.pppg++ <--> Core1.pppg++;
        Pod49.pppg++ <--> Core2.pppg++;
        Pod49.pppg++ <--> Core3.pppg++;
        Pod50.pppg++ <--> Core4.pppg++;
        Pod50.pppg++ <--> Core5.pppg++;
        Pod50.pppg++ <--> Core6.pppg++;
        Pod50.pppg++ <--> Core7.pppg++;
        Pod51.pppg++ <--> Core8.pppg++;
        Pod51.pppg++ <--> Core9.pppg++;
        Pod51.pppg++ <--> Core10.pppg++;
        Pod51.pppg++ <--> Core11.pppg++;
        Pod52.pppg++ <--> Core12.pppg++;
        Pod52.pppg++ <--> Core13.pppg++;
        Pod52.pppg++ <--> Core14.pppg++;
        Pod52.pppg++ <--> Core15.pppg++;
        Pod57.pppg++ <--> Core0.pppg++;
        Pod57.pppg++ <--> Core1.pppg++;
        Pod57.pppg++ <--> Core2.pppg++;
        Pod57.pppg++ <--> Core3.pppg++;
        Pod58.pppg++ <--> Core4.pppg++;
        Pod58.pppg++ <--> Core5.pppg++;
        Pod58.pppg++ <--> Core6.pppg++;
        Pod58.pppg++ <--> Core7.pppg++;
        Pod59.pppg++ <--> Core8.pppg++;
        Pod59.pppg++ <--> Core9.pppg++;
        Pod59.pppg++ <--> Core10.pppg++;
        Pod59.pppg++ <--> Core11.pppg++;
        Pod60.pppg++ <--> Core12.pppg++;
        Pod60.pppg++ <--> Core13.pppg++;
        Pod60.pppg++ <--> Core14.pppg++;
        Pod60.pppg++ <--> Core15.pppg++;
}

network DCTCPLeafSpine
{
    parameters:
        @display("bgb=1811,693");
    //        double ldelay @unit(s) = default(0.1s);
    //        double ldatarate @unit(Mbps) = default(10Mbps);
    types:
        channel NormalP extends DatarateChannel
        {
            parameters:
                datarate = 10Gbps;
                per = 0;
                ber = 0;
                delay = 20us;
        }
        channel HighP extends DatarateChannel
        {
            parameters:
                datarate = 40Gbps;
                per = 0;
                ber = 0;
                delay = 20us;
        }


    submodules:
        Leaf1: SplitTCPRouter {
            parameters:
                @display("p=110,233;i=abstract/router");
        }
        configurator: IPv4NetworkConfigurator {
            @display("p=1777,45");
        }
        Spine1: SplitTCPRouter {
            @display("p=562,91");
        }
        Spine2: SplitTCPRouter {
            @display("p=754,91");
        }
        Spine3: SplitTCPRouter {
            @display("p=954,91");
        }
        Spine4: SplitTCPRouter {
            @display("p=1135,91");
        }
        client1: StandardHost2 {
            parameters:
                @display("p=38,346");
        }
        client2: StandardHost2 {
            parameters:
                @display("p=84,346");
        }
        client3: StandardHost2 {
            parameters:
                @display("p=132,346");
        }
        client4: StandardHost2 {
            parameters:
                @display("p=177,346");
        }
        client5: StandardHost2 {
            parameters:
                @display("p=38,406");
        }
        client6: StandardHost2 {
            parameters:
                @display("p=84,406");
        }
        client7: StandardHost2 {
            parameters:
                @display("p=132,406");
        }
        client8: StandardHost2 {
            parameters:
                @display("p=177,406");
        }
        client9: StandardHost2 {
            parameters:
                @display("p=38,469");
        }
        client10: StandardHost2 {
            parameters:
                @display("p=84,469");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=132,469");
        }
        client12: StandardHost2 {
            parameters:
                @display("p=177,469");
        }
        client13: StandardHost2 {
            parameters:
                @display("p=38,532");
        }
        client14: StandardHost2 {
            parameters:
                @display("p=84,532");
        }
        client15: StandardHost2 {
            parameters:
                @display("p=132,532");
        }
        client16: StandardHost2 {
            parameters:
                @display("p=177,532");
        }
        client17: StandardHost2 {
            parameters:
                @display("p=230,346");
        }
        client18: StandardHost2 {
            parameters:
                @display("p=276,346");
        }
        client19: StandardHost2 {
            parameters:
                @display("p=324,346");
        }
        client20: StandardHost2 {
            parameters:
                @display("p=369,346");
        }
        client21: StandardHost2 {
            parameters:
                @display("p=230,406");
        }
        client22: StandardHost2 {
            parameters:
                @display("p=276,406");
        }
        client23: StandardHost2 {
            parameters:
                @display("p=324,406");
        }
        client24: StandardHost2 {
            parameters:
                @display("p=369,406");
        }
        client25: StandardHost2 {
            parameters:
                @display("p=230,469");
        }
        client26: StandardHost2 {
            parameters:
                @display("p=276,469");
        }
        client27: StandardHost2 {
            parameters:
                @display("p=324,469");
        }
        client28: StandardHost2 {
            parameters:
                @display("p=369,469");
        }
        client29: StandardHost2 {
            parameters:
                @display("p=230,532");
        }
        client30: StandardHost2 {
            parameters:
                @display("p=276,532");
        }
        client31: StandardHost2 {
            parameters:
                @display("p=324,532");
        }
        client32: StandardHost2 {
            parameters:
                @display("p=369,532");
        }
        Leaf2: SplitTCPRouter {
            parameters:
                @display("p=302,233;i=abstract/router");
        }
        client33: StandardHost2 {
            parameters:
                @display("p=416,346");
        }
        client34: StandardHost2 {
            parameters:
                @display("p=462,346");
        }
        client35: StandardHost2 {
            parameters:
                @display("p=510,346");
        }
        client36: StandardHost2 {
            parameters:
                @display("p=555,346");
        }
        client37: StandardHost2 {
            parameters:
                @display("p=416,406");
        }
        client38: StandardHost2 {
            parameters:
                @display("p=462,406");
        }
        client39: StandardHost2 {
            parameters:
                @display("p=510,406");
        }
        client40: StandardHost2 {
            parameters:
                @display("p=555,406");
        }
        client41: StandardHost2 {
            parameters:
                @display("p=416,469");
        }
        client42: StandardHost2 {
            parameters:
                @display("p=462,469");
        }
        client43: StandardHost2 {
            parameters:
                @display("p=510,469");
        }
        client44: StandardHost2 {
            parameters:
                @display("p=555,469");
        }
        client45: StandardHost2 {
            parameters:
                @display("p=416,532");
        }
        client46: StandardHost2 {
            parameters:
                @display("p=462,532");
        }
        client47: StandardHost2 {
            parameters:
                @display("p=510,532");
        }
        client48: StandardHost2 {
            parameters:
                @display("p=555,532");
        }
        Leaf3: SplitTCPRouter {
            parameters:
                @display("p=488,233;i=abstract/router");
        }
        client49: StandardHost2 {
            parameters:
                @display("p=608,346");
        }
        client50: StandardHost2 {
            parameters:
                @display("p=654,346");
        }
        client51: StandardHost2 {
            parameters:
                @display("p=702,346");
        }
        client52: StandardHost2 {
            parameters:
                @display("p=747,346");
        }
        client53: StandardHost2 {
            parameters:
                @display("p=608,406");
        }
        client54: StandardHost2 {
            parameters:
                @display("p=654,406");
        }
        client55: StandardHost2 {
            parameters:
                @display("p=702,406");
        }
        client56: StandardHost2 {
            parameters:
                @display("p=747,406");
        }
        client57: StandardHost2 {
            parameters:
                @display("p=608,469");
        }
        client58: StandardHost2 {
            parameters:
                @display("p=654,469");
        }
        client59: StandardHost2 {
            parameters:
                @display("p=702,469");
        }
        client60: StandardHost2 {
            parameters:
                @display("p=747,469");
        }
        client61: StandardHost2 {
            parameters:
                @display("p=608,532");
        }
        client62: StandardHost2 {
            parameters:
                @display("p=654,532");
        }
        client63: StandardHost2 {
            parameters:
                @display("p=702,532");
        }
        client64: StandardHost2 {
            parameters:
                @display("p=747,532");
        }
        Leaf4: SplitTCPRouter {
            parameters:
                @display("p=680,233;i=abstract/router");
        }
        client65: StandardHost2 {
            parameters:
                @display("p=798,346");
        }
        client66: StandardHost2 {
            parameters:
                @display("p=844,346");
        }
        client67: StandardHost2 {
            parameters:
                @display("p=892,346");
        }
        client68: StandardHost2 {
            parameters:
                @display("p=937,346");
        }
        client69: StandardHost2 {
            parameters:
                @display("p=798,406");
        }
        client70: StandardHost2 {
            parameters:
                @display("p=844,406");
        }
        client71: StandardHost2 {
            parameters:
                @display("p=892,406");
        }
        client72: StandardHost2 {
            parameters:
                @display("p=937,406");
        }
        client73: StandardHost2 {
            parameters:
                @display("p=798,469");
        }
        client74: StandardHost2 {
            parameters:
                @display("p=844,469");
        }
        client75: StandardHost2 {
            parameters:
                @display("p=892,469");
        }
        client76: StandardHost2 {
            parameters:
                @display("p=937,469");
        }
        client77: StandardHost2 {
            parameters:
                @display("p=798,532");
        }
        client78: StandardHost2 {
            parameters:
                @display("p=844,532");
        }
        client79: StandardHost2 {
            parameters:
                @display("p=892,532");
        }
        client80: StandardHost2 {
            parameters:
                @display("p=937,532");
        }
        Leaf5: SplitTCPRouter {
            parameters:
                @display("p=870,233;i=abstract/router");
        }
        client81: StandardHost2 {
            parameters:
                @display("p=984,346");
        }
        client82: StandardHost2 {
            parameters:
                @display("p=1030,346");
        }
        client83: StandardHost2 {
            parameters:
                @display("p=1078,346");
        }
        client84: StandardHost2 {
            parameters:
                @display("p=1123,346");
        }
        client85: StandardHost2 {
            parameters:
                @display("p=984,406");
        }
        client86: StandardHost2 {
            parameters:
                @display("p=1030,406");
        }
        client87: StandardHost2 {
            parameters:
                @display("p=1078,406");
        }
        client88: StandardHost2 {
            parameters:
                @display("p=1123,406");
        }
        client89: StandardHost2 {
            parameters:
                @display("p=984,469");
        }
        client90: StandardHost2 {
            parameters:
                @display("p=1030,469");
        }
        client91: StandardHost2 {
            parameters:
                @display("p=1078,469");
        }
        client92: StandardHost2 {
            parameters:
                @display("p=1123,469");
        }
        client93: StandardHost2 {
            parameters:
                @display("p=984,532");
        }
        client94: StandardHost2 {
            parameters:
                @display("p=1030,532");
        }
        client95: StandardHost2 {
            parameters:
                @display("p=1078,532");
        }
        client96: StandardHost2 {
            parameters:
                @display("p=1123,532");
        }
        Leaf6: SplitTCPRouter {
            parameters:
                @display("p=1056,233;i=abstract/router");
        }
        client97: StandardHost2 {
            parameters:
                @display("p=1174,346");
        }
        client98: StandardHost2 {
            parameters:
                @display("p=1220,346");
        }
        client99: StandardHost2 {
            parameters:
                @display("p=1268,346");
        }
        client100: StandardHost2 {
            parameters:
                @display("p=1313,346");
        }
        client101: StandardHost2 {
            parameters:
                @display("p=1174,406");
        }
        client102: StandardHost2 {
            parameters:
                @display("p=1220,406");
        }
        client103: StandardHost2 {
            parameters:
                @display("p=1268,406");
        }
        client104: StandardHost2 {
            parameters:
                @display("p=1313,406");
        }
        client105: StandardHost2 {
            parameters:
                @display("p=1174,469");
        }
        client106: StandardHost2 {
            parameters:
                @display("p=1220,469");
        }
        client107: StandardHost2 {
            parameters:
                @display("p=1268,469");
        }
        client108: StandardHost2 {
            parameters:
                @display("p=1313,469");
        }
        client109: StandardHost2 {
            parameters:
                @display("p=1174,532");
        }
        client110: StandardHost2 {
            parameters:
                @display("p=1220,532");
        }
        client111: StandardHost2 {
            parameters:
                @display("p=1268,532");
        }
        client112: StandardHost2 {
            parameters:
                @display("p=1313,532");
        }
        Leaf7: SplitTCPRouter {
            parameters:
                @display("p=1246,233;i=abstract/router");
        }
        client113: StandardHost2 {
            parameters:
                @display("p=1359,346");
        }
        client114: StandardHost2 {
            parameters:
                @display("p=1405,346");
        }
        client115: StandardHost2 {
            parameters:
                @display("p=1453,346");
        }
        client116: StandardHost2 {
            parameters:
                @display("p=1498,346");
        }
        client117: StandardHost2 {
            parameters:
                @display("p=1359,406");
        }
        client118: StandardHost2 {
            parameters:
                @display("p=1405,406");
        }
        client119: StandardHost2 {
            parameters:
                @display("p=1453,406");
        }
        client120: StandardHost2 {
            parameters:
                @display("p=1498,406");
        }
        client121: StandardHost2 {
            parameters:
                @display("p=1359,469");
        }
        client122: StandardHost2 {
            parameters:
                @display("p=1405,469");
        }
        client123: StandardHost2 {
            parameters:
                @display("p=1453,469");
        }
        client124: StandardHost2 {
            parameters:
                @display("p=1498,469");
        }
        client125: StandardHost2 {
            parameters:
                @display("p=1359,532");
        }
        client126: StandardHost2 {
            parameters:
                @display("p=1405,532");
        }
        client127: StandardHost2 {
            parameters:
                @display("p=1453,532");
        }
        client128: StandardHost2 {
            parameters:
                @display("p=1498,532");
        }
        Leaf8: SplitTCPRouter {
            parameters:
                @display("p=1431,233;i=abstract/router");
        }
        client129: StandardHost2 {
            parameters:
                @display("p=1544,346");
        }
        client130: StandardHost2 {
            parameters:
                @display("p=1590,346");
        }
        client131: StandardHost2 {
            parameters:
                @display("p=1638,346");
        }
        client132: StandardHost2 {
            parameters:
                @display("p=1683,346");
        }
        client133: StandardHost2 {
            parameters:
                @display("p=1544,406");
        }
        client134: StandardHost2 {
            parameters:
                @display("p=1590,406");
        }
        client135: StandardHost2 {
            parameters:
                @display("p=1638,406");
        }
        client136: StandardHost2 {
            parameters:
                @display("p=1683,406");
        }
        client137: StandardHost2 {
            parameters:
                @display("p=1544,469");
        }
        client138: StandardHost2 {
            parameters:
                @display("p=1590,469");
        }
        client139: StandardHost2 {
            parameters:
                @display("p=1638,469");
        }
        client140: StandardHost2 {
            parameters:
                @display("p=1683,469");
        }
        client141: StandardHost2 {
            parameters:
                @display("p=1544,532");
        }
        client142: StandardHost2 {
            parameters:
                @display("p=1590,532");
        }
        client143: StandardHost2 {
            parameters:
                @display("p=1638,532");
        }
        client144: StandardHost2 {
            parameters:
                @display("p=1683,532");
        }
        Leaf9: SplitTCPRouter {
            parameters:
                @display("p=1616,233;i=abstract/router");
        }
    connections:
        client1.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client2.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client3.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client4.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client5.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client6.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client7.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client8.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client9.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client10.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client11.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client12.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client13.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client14.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client15.pppg++ <--> NormalP <--> Leaf1.pppg++;
        client16.pppg++ <--> NormalP <--> Leaf1.pppg++;
        Leaf1.pppg++ <--> HighP <--> Spine1.pppg++;
        Leaf1.pppg++ <--> HighP <--> Spine2.pppg++;
        Leaf1.pppg++ <--> HighP <--> Spine3.pppg++;
        Leaf1.pppg++ <--> HighP <--> Spine4.pppg++;
        client22.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client31.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client23.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client19.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client26.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client25.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client27.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client32.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client28.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client17.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client18.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client30.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client21.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client29.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client20.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client24.pppg++ <--> NormalP <--> Leaf2.pppg++;
        client38.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client47.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client39.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client35.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client42.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client41.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client43.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client48.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client44.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client33.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client34.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client46.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client37.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client45.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client36.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client40.pppg++ <--> NormalP <--> Leaf3.pppg++;
        client54.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client63.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client55.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client51.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client58.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client57.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client59.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client64.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client60.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client49.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client50.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client62.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client53.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client61.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client52.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client56.pppg++ <--> NormalP <--> Leaf4.pppg++;
        client70.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client79.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client71.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client67.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client74.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client73.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client75.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client80.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client76.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client65.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client66.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client78.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client69.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client77.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client68.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client72.pppg++ <--> NormalP <--> Leaf5.pppg++;
        client86.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client95.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client87.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client83.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client90.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client89.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client91.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client96.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client92.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client81.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client82.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client94.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client85.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client93.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client84.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client88.pppg++ <--> NormalP <--> Leaf6.pppg++;
        client112.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client100.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client101.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client97.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client110.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client108.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client103.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client111.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client102.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client105.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client107.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client104.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client109.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client98.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client99.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client106.pppg++ <--> NormalP <--> Leaf7.pppg++;
        client128.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client116.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client117.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client113.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client126.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client124.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client119.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client127.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client118.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client121.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client123.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client120.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client125.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client114.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client115.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client122.pppg++ <--> NormalP <--> Leaf8.pppg++;
        client144.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client132.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client133.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client129.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client142.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client140.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client135.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client143.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client134.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client137.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client139.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client136.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client141.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client130.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client131.pppg++ <--> NormalP <--> Leaf9.pppg++;
        client138.pppg++ <--> NormalP <--> Leaf9.pppg++;
        Leaf2.pppg++ <--> HighP <--> Spine1.pppg++;
        Leaf2.pppg++ <--> HighP <--> Spine3.pppg++;
        Leaf2.pppg++ <--> HighP <--> Spine4.pppg++;
        Leaf2.pppg++ <--> HighP <--> Spine2.pppg++;
        Leaf3.pppg++ <--> HighP <--> Spine1.pppg++;
        Leaf3.pppg++ <--> HighP <--> Spine2.pppg++;
        Leaf3.pppg++ <--> HighP <--> Spine3.pppg++;
        Leaf3.pppg++ <--> HighP <--> Spine4.pppg++;
        Leaf4.pppg++ <--> HighP <--> Spine1.pppg++;
        Leaf4.pppg++ <--> HighP <--> Spine2.pppg++;
        Leaf4.pppg++ <--> HighP <--> Spine3.pppg++;
        Leaf4.pppg++ <--> HighP <--> Spine4.pppg++;
        Leaf5.pppg++ <--> HighP <--> Spine1.pppg++;
        Leaf5.pppg++ <--> HighP <--> Spine2.pppg++;
        Leaf5.pppg++ <--> HighP <--> Spine3.pppg++;
        Leaf5.pppg++ <--> HighP <--> Spine4.pppg++;
        Leaf6.pppg++ <--> HighP <--> Spine1.pppg++;
        Leaf6.pppg++ <--> HighP <--> Spine2.pppg++;
        Leaf6.pppg++ <--> HighP <--> Spine3.pppg++;
        Leaf6.pppg++ <--> HighP <--> Spine4.pppg++;
        Leaf7.pppg++ <--> HighP <--> Spine1.pppg++;
        Leaf7.pppg++ <--> HighP <--> Spine2.pppg++;
        Leaf7.pppg++ <--> HighP <--> Spine3.pppg++;
        Leaf7.pppg++ <--> HighP <--> Spine4.pppg++;
        Leaf8.pppg++ <--> HighP <--> Spine1.pppg++;
        Leaf8.pppg++ <--> HighP <--> Spine2.pppg++;
        Leaf8.pppg++ <--> HighP <--> Spine3.pppg++;
        Leaf8.pppg++ <--> HighP <--> Spine4.pppg++;
        Leaf9.pppg++ <--> HighP <--> Spine1.pppg++;
        Leaf9.pppg++ <--> HighP <--> Spine2.pppg++;
        Leaf9.pppg++ <--> HighP <--> Spine3.pppg++;
        Leaf9.pppg++ <--> HighP <--> Spine4.pppg++;
}
