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
        @display("bgb=637,580");
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