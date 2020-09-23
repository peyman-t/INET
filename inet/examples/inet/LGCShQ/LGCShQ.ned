//
// author: Thomas Reschka
//

package inet.examples.inet.LGCShQ;

import inet.networklayer.autorouting.ipv4.IPv4NetworkConfigurator;
import inet.nodes.inet.Router;
import inet.nodes.inet.SplitTCPRouter;
import inet.nodes.inet.StandardHost;
import inet.nodes.inet.StandardHost2;
import ned.DatarateChannel;

import inet.linklayer.queue.REDDropper;

import inet.linklayer.IOutputQueue;
import inet.linklayer.queue.DropTailQueue;
import inet.linklayer.queue.FIFOQueue;
import inet.linklayer.queue.REDDropperNUM;
import inet.linklayer.queue.REDDropperNUMDual;
import inet.linklayer.queue.REDDropperNUMDual2;
import inet.linklayer.queue.REDDropperShQ;

module REDQueueShQ like IOutputQueue
{
    gates:
        input in;
        output out;

    submodules:
        red: REDDropperShQ {
            numGates = 1;
            wq = default(0.0002);
            minths = default("10");
            maxths = default("40");
            maxps = default("0.10");
            pkrates = default("8333.333");
        }
        fifo: FIFOQueue;
    connections:
        in --> red.in[0];
        red.out[0] --> fifo.in++;
        fifo.out --> out;
}

//module REDQueueNUM like IOutputQueue
//{
//    gates:
//        input in;
//        output out;
//
//    submodules:
//        red: REDDropperNUM {
//            numGates = 1;
//            wq = default(0.002);
//            minths = default("10");
//            maxths = default("40");
//            maxps = default("0.10");
//            pkrates = default("8333.333");
//        }
//        fifo: FIFOQueue;
//    connections:
//        in --> red.in[0];
//        red.out[0] --> fifo.in++;
//        fifo.out --> out;
//}

//module REDQueueNUMDual like IOutputQueue
//{
//    gates:
//        input in;
//        output out;
//
//    submodules:
//        red: REDDropperNUMDual {
//            numGates = 1;
//            wq = default(0.002);
//            minths = default("10");
//            maxths = default("40");
//            maxps = default("0.10");
//            pkrates = default("8333.333");
//        }
//        fifo: FIFOQueue;
//    connections:
//        in --> red.in[0];
//        red.out[0] --> fifo.in++;
//        fifo.out --> out;
//}
//
//module REDQueueNUMDual2 like IOutputQueue
//{
//    gates:
//        input in;
//        output out;
//
//    submodules:
//        red: REDDropperNUMDual2 {
//            numGates = 1;
//            wq = default(0.0002);
//            minths = default("10");
//            maxths = default("40");
//            maxps = default("0.10");
//            pkrates = default("8333.333");
//        }
//        fifo: FIFOQueue;
//    connections:
//        in --> red.in[0];
//        red.out[0] --> fifo.in++;
//        fifo.out --> out;
//}


network Dumbbell
{
    parameters:
        @display("bgb=740,580");
    //        double ldelay @unit(s) = default(0.1s);
    //        double ldatarate @unit(Mbps) = default(10Mbps);
    types:
        channel NormalP extends DatarateChannel
        {
            parameters:
                datarate = 100Mbps;
                delay = 3ms;
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

network ParkingLot
{
    parameters:
        @display("bgb=1192,1042");
    //        double ldelay @unit(s) = default(0.1s);
    //            double ldatarate @unit(Mbps) = default(10Mbps);
    types:
        channel NormalP extends DatarateChannel
        {
            parameters:
                datarate = 1Gbps;
                delay = 1ms;
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
                @display("p=463,128;i=abstract/router");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=117,260");
        }
        client12: StandardHost2 {
            parameters:
                @display("p=183,317");
        }
        client23: StandardHost2 {
            parameters:
                @display("p=495,260");
        }
        configurator: IPv4NetworkConfigurator;
        routerCore1: SplitTCPRouter {
            parameters:
                @display("p=307,128;i=abstract/router");
        }
        client22: StandardHost2 {
            parameters:
                @display("p=335,260");
        }
        client13: StandardHost2 {
            parameters:
                @display("p=252,317");
        }
        routerCore3: SplitTCPRouter {
            parameters:
                @display("p=644,128;i=abstract/router");
        }
        client24: StandardHost2 {
            parameters:
                @display("p=673,260");
        }
        client14: StandardHost2 {
            parameters:
                @display("p=407,317");
        }
        client21: StandardHost2 {
            parameters:
                @display("p=1160,260");
        }
        routerCore4: SplitTCPRouter {
            parameters:
                @display("p=828,128;i=abstract/router");
        }
        client15: StandardHost2 {
            parameters:
                @display("p=594,317");
        }
        client25: StandardHost2 {
            parameters:
                @display("p=888,260");
        }
        routerCore5: SplitTCPRouter {
            parameters:
                @display("p=999,119;i=abstract/router");
        }
        client16: StandardHost2 {
            parameters:
                @display("p=789,317");
        }
        client26: StandardHost2 {
            parameters:
                @display("p=999,260");
        }
        client111: StandardHost2 {
            parameters:
                @display("p=117,317");
        }
        client112: StandardHost2 {
            parameters:
                @display("p=117,366");
        }
        client113: StandardHost2 {
            parameters:
                @display("p=117,420");
        }
        client114: StandardHost2 {
            parameters:
                @display("p=117,473");
        }
        client115: StandardHost2 {
            parameters:
                @display("p=117,524");
        }
        client116: StandardHost2 {
            parameters:
                @display("p=117,574");
        }
        client117: StandardHost2 {
            parameters:
                @display("p=117,626");
        }
        client118: StandardHost2 {
            parameters:
                @display("p=117,678");
        }
        client119: StandardHost2 {
            parameters:
                @display("p=117,733");
        }
        client1110: StandardHost2 {
            parameters:
                @display("p=117,792");
        }
        client1111: StandardHost2 {
            parameters:
                @display("p=117,837");
        }
        client1112: StandardHost2 {
            parameters:
                @display("p=117,886");
        }
        client1113: StandardHost2 {
            parameters:
                @display("p=117,934");
        }
        client1114: StandardHost2 {
            parameters:
                @display("p=117,986");
        }
        client1115: StandardHost2 {
            parameters:
                @display("p=63,260");
        }
        client1116: StandardHost2 {
            parameters:
                @display("p=63,317");
        }
        client1117: StandardHost2 {
            parameters:
                @display("p=63,366");
        }
        client1118: StandardHost2 {
            parameters:
                @display("p=63,420");
        }
        client1119: StandardHost2 {
            parameters:
                @display("p=63,473");
        }
        client1120: StandardHost2 {
            parameters:
                @display("p=63,524");
        }
        client1121: StandardHost2 {
            parameters:
                @display("p=63,574");
        }
        client1122: StandardHost2 {
            parameters:
                @display("p=63,626");
        }
        client1123: StandardHost2 {
            parameters:
                @display("p=63,678");
        }
        client1124: StandardHost2 {
            parameters:
                @display("p=63,733");
        }
        client1125: StandardHost2 {
            parameters:
                @display("p=63,786");
        }
        client1126: StandardHost2 {
            parameters:
                @display("p=63,837");
        }
        client1127: StandardHost2 {
            parameters:
                @display("p=63,886");
        }
        client1128: StandardHost2 {
            parameters:
                @display("p=63,934");
        }
        client1129: StandardHost2 {
            parameters:
                @display("p=63,986");
        }
        client121: StandardHost2 {
            parameters:
                @display("p=183,366");
        }
        client122: StandardHost2 {
            parameters:
                @display("p=183,420");
        }
        client123: StandardHost2 {
            parameters:
                @display("p=183,473");
        }
        client124: StandardHost2 {
            parameters:
                @display("p=183,524");
        }
        client125: StandardHost2 {
            parameters:
                @display("p=183,574");
        }
        client126: StandardHost2 {
            parameters:
                @display("p=183,626");
        }
        client127: StandardHost2 {
            parameters:
                @display("p=183,678");
        }
        client131: StandardHost2 {
            parameters:
                @display("p=252,366");
        }
        client132: StandardHost2 {
            parameters:
                @display("p=252,420");
        }
        client133: StandardHost2 {
            parameters:
                @display("p=252,473");
        }
        client134: StandardHost2 {
            parameters:
                @display("p=252,524");
        }
        client135: StandardHost2 {
            parameters:
                @display("p=252,574");
        }
        client136: StandardHost2 {
            parameters:
                @display("p=252,626");
        }
        client137: StandardHost2 {
            parameters:
                @display("p=252,678");
        }
        client221: StandardHost2 {
            parameters:
                @display("p=335,317");
        }
        client222: StandardHost2 {
            parameters:
                @display("p=335,366");
        }
        client223: StandardHost2 {
            parameters:
                @display("p=335,420");
        }
        client224: StandardHost2 {
            parameters:
                @display("p=335,473");
        }
        client225: StandardHost2 {
            parameters:
                @display("p=335,524");
        }
        client226: StandardHost2 {
            parameters:
                @display("p=335,574");
        }
        client227: StandardHost2 {
            parameters:
                @display("p=335,626");
        }
        client141: StandardHost2 {
            parameters:
                @display("p=407,366");
        }
        client142: StandardHost2 {
            parameters:
                @display("p=407,420");
        }
        client143: StandardHost2 {
            parameters:
                @display("p=407,473");
        }
        client144: StandardHost2 {
            parameters:
                @display("p=407,524");
        }
        client145: StandardHost2 {
            parameters:
                @display("p=407,574");
        }
        client146: StandardHost2 {
            parameters:
                @display("p=407,626");
        }
        client147: StandardHost2 {
            parameters:
                @display("p=407,678");
        }
        client231: StandardHost2 {
            parameters:
                @display("p=495,317");
        }
        client232: StandardHost2 {
            parameters:
                @display("p=495,366");
        }
        client233: StandardHost2 {
            parameters:
                @display("p=495,420");
        }
        client234: StandardHost2 {
            parameters:
                @display("p=495,473");
        }
        client235: StandardHost2 {
            parameters:
                @display("p=495,524");
        }
        client236: StandardHost2 {
            parameters:
                @display("p=495,574");
        }
        client237: StandardHost2 {
            parameters:
                @display("p=495,626");
        }
        client151: StandardHost2 {
            parameters:
                @display("p=594,366");
        }
        client152: StandardHost2 {
            parameters:
                @display("p=594,420");
        }
        client153: StandardHost2 {
            parameters:
                @display("p=594,473");
        }
        client154: StandardHost2 {
            parameters:
                @display("p=594,524");
        }
        client155: StandardHost2 {
            parameters:
                @display("p=594,574");
        }
        client156: StandardHost2 {
            parameters:
                @display("p=594,626");
        }
        client157: StandardHost2 {
            parameters:
                @display("p=594,678");
        }
        client241: StandardHost2 {
            parameters:
                @display("p=673,317");
        }
        client242: StandardHost2 {
            parameters:
                @display("p=673,366");
        }
        client243: StandardHost2 {
            parameters:
                @display("p=673,420");
        }
        client244: StandardHost2 {
            parameters:
                @display("p=673,473");
        }
        client245: StandardHost2 {
            parameters:
                @display("p=673,524");
        }
        client246: StandardHost2 {
            parameters:
                @display("p=673,574");
        }
        client247: StandardHost2 {
            parameters:
                @display("p=673,626");
        }
        client161: StandardHost2 {
            parameters:
                @display("p=789,366");
        }
        client162: StandardHost2 {
            parameters:
                @display("p=789,420");
        }
        client163: StandardHost2 {
            parameters:
                @display("p=789,473");
        }
        client164: StandardHost2 {
            parameters:
                @display("p=789,524");
        }
        client165: StandardHost2 {
            parameters:
                @display("p=789,574");
        }
        client166: StandardHost2 {
            parameters:
                @display("p=789,626");
        }
        client167: StandardHost2 {
            parameters:
                @display("p=789,678");
        }
        client251: StandardHost2 {
            parameters:
                @display("p=888,317");
        }
        client252: StandardHost2 {
            parameters:
                @display("p=888,366");
        }
        client253: StandardHost2 {
            parameters:
                @display("p=888,420");
        }
        client254: StandardHost2 {
            parameters:
                @display("p=888,473");
        }
        client255: StandardHost2 {
            parameters:
                @display("p=888,524");
        }
        client256: StandardHost2 {
            parameters:
                @display("p=888,574");
        }
        client257: StandardHost2 {
            parameters:
                @display("p=888,626");
        }
        client261: StandardHost2 {
            parameters:
                @display("p=999,317");
        }
        client262: StandardHost2 {
            parameters:
                @display("p=999,366");
        }
        client263: StandardHost2 {
            parameters:
                @display("p=999,420");
        }
        client264: StandardHost2 {
            parameters:
                @display("p=999,473");
        }
        client265: StandardHost2 {
            parameters:
                @display("p=999,524");
        }
        client266: StandardHost2 {
            parameters:
                @display("p=999,574");
        }
        client267: StandardHost2 {
            parameters:
                @display("p=999,626");
        }
        client211: StandardHost2 {
            parameters:
                @display("p=1153,317");
        }
        client212: StandardHost2 {
            parameters:
                @display("p=1153,366");
        }
        client213: StandardHost2 {
            parameters:
                @display("p=1153,420");
        }
        client214: StandardHost2 {
            parameters:
                @display("p=1153,473");
        }
        client215: StandardHost2 {
            parameters:
                @display("p=1153,524");
        }
        client216: StandardHost2 {
            parameters:
                @display("p=1153,574");
        }
        client217: StandardHost2 {
            parameters:
                @display("p=1153,626");
        }
        client218: StandardHost2 {
            parameters:
                @display("p=1153,678");
        }
        client219: StandardHost2 {
            parameters:
                @display("p=1153,733");
        }
        client2110: StandardHost2 {
            parameters:
                @display("p=1153,792");
        }
        client2111: StandardHost2 {
            parameters:
                @display("p=1153,837");
        }
        client2112: StandardHost2 {
            parameters:
                @display("p=1153,886");
        }
        client2113: StandardHost2 {
            parameters:
                @display("p=1153,934");
        }
        client2114: StandardHost2 {
            parameters:
                @display("p=1153,986");
        }
        client2115: StandardHost2 {
            parameters:
                @display("p=1099,260");
        }
        client2116: StandardHost2 {
            parameters:
                @display("p=1099,317");
        }
        client2117: StandardHost2 {
            parameters:
                @display("p=1099,366");
        }
        client2118: StandardHost2 {
            parameters:
                @display("p=1099,420");
        }
        client2119: StandardHost2 {
            parameters:
                @display("p=1099,473");
        }
        client2120: StandardHost2 {
            parameters:
                @display("p=1099,524");
        }
        client2121: StandardHost2 {
            parameters:
                @display("p=1099,574");
        }
        client2122: StandardHost2 {
            parameters:
                @display("p=1099,626");
        }
        client2123: StandardHost2 {
            parameters:
                @display("p=1099,678");
        }
        client2124: StandardHost2 {
            parameters:
                @display("p=1099,733");
        }
        client2125: StandardHost2 {
            parameters:
                @display("p=1099,786");
        }
        client2126: StandardHost2 {
            parameters:
                @display("p=1099,837");
        }
        client2127: StandardHost2 {
            parameters:
                @display("p=1099,886");
        }
        client2128: StandardHost2 {
            parameters:
                @display("p=1099,934");
        }
        client2129: StandardHost2 {
            parameters:
                @display("p=1099,986");
        }
    connections:
        routerCore.pppg++ <--> NormalP <--> client11.pppg++;
        routerCore.pppg++ <--> NormalP <--> client12.pppg++;
        routerCore2.pppg++ <--> NormalP <--> client23.pppg++;
        routerCore.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client22.pppg++ <--> NormalP <--> routerCore1.pppg++;
        routerCore1.pppg++ <--> NormalP <--> routerCore2.pppg++;
        routerCore2.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client13.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client14.pppg++ <--> NormalP <--> routerCore2.pppg++;
        routerCore3.pppg++ <--> NormalP <--> client24.pppg++;
        routerCore3.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client15.pppg++ <--> NormalP <--> routerCore3.pppg++;
        routerCore4.pppg++ <--> NormalP <--> client25.pppg++;
        routerCore4.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client16.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client26.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client21.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client1115.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1116.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1117.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1118.pppg++ <--> NormalP <--> routerCore.pppg++;
        client111.pppg++ <--> NormalP <--> routerCore.pppg++;
        client112.pppg++ <--> NormalP <--> routerCore.pppg++;
        client113.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1119.pppg++ <--> NormalP <--> routerCore.pppg++;
        client114.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1120.pppg++ <--> NormalP <--> routerCore.pppg++;
        client115.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1121.pppg++ <--> NormalP <--> routerCore.pppg++;
        client116.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1122.pppg++ <--> NormalP <--> routerCore.pppg++;
        client117.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1123.pppg++ <--> NormalP <--> routerCore.pppg++;
        client118.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1124.pppg++ <--> NormalP <--> routerCore.pppg++;
        client119.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1125.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1110.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1126.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1111.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1127.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1112.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1128.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1113.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1129.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1114.pppg++ <--> NormalP <--> routerCore.pppg++;
        client121.pppg++ <--> NormalP <--> routerCore.pppg++;
        client122.pppg++ <--> NormalP <--> routerCore.pppg++;
        client123.pppg++ <--> NormalP <--> routerCore.pppg++;
        client124.pppg++ <--> NormalP <--> routerCore.pppg++;
        client125.pppg++ <--> NormalP <--> routerCore.pppg++;
        client126.pppg++ <--> NormalP <--> routerCore.pppg++;
        client127.pppg++ <--> NormalP <--> routerCore.pppg++;
        client131.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client132.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client133.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client134.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client135.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client136.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client137.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client221.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client222.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client223.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client224.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client225.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client226.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client227.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client141.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client142.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client143.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client144.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client145.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client146.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client147.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client231.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client232.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client233.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client234.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client235.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client236.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client237.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client151.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client152.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client153.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client154.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client155.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client156.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client157.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client241.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client242.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client243.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client244.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client245.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client246.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client247.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client161.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client162.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client163.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client164.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client165.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client166.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client167.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client251.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client252.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client253.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client254.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client255.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client256.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client257.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client261.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client262.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client263.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client264.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client265.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client266.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client267.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2115.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2116.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client211.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2117.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client212.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2118.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client213.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2119.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client214.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2120.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client215.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2121.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client216.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2122.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client217.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2123.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client218.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2124.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client219.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2125.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2110.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2111.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2126.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2112.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2127.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2113.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2128.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2114.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2129.pppg++ <--> NormalP <--> routerCore5.pppg++;
}

network ParkingLot50
{
    parameters:
        @display("bgb=1192,1042");
    //        double ldelay @unit(s) = default(0.1s);
    //            double ldatarate @unit(Mbps) = default(10Mbps);
    types:
        channel NormalP extends DatarateChannel
        {
            parameters:
                datarate = 40Mbps;
                delay = 1ms;
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
                @display("p=463,128;i=abstract/router");
        }
        client11: StandardHost2 {
            parameters:
                @display("p=117,260");
        }
        client12: StandardHost2 {
            parameters:
                @display("p=183,317");
        }
        client23: StandardHost2 {
            parameters:
                @display("p=495,260");
        }
        configurator: IPv4NetworkConfigurator;
        routerCore1: SplitTCPRouter {
            parameters:
                @display("p=307,128;i=abstract/router");
        }
        client22: StandardHost2 {
            parameters:
                @display("p=335,260");
        }
        client13: StandardHost2 {
            parameters:
                @display("p=252,317");
        }
        routerCore3: SplitTCPRouter {
            parameters:
                @display("p=644,128;i=abstract/router");
        }
        client24: StandardHost2 {
            parameters:
                @display("p=673,260");
        }
        client14: StandardHost2 {
            parameters:
                @display("p=407,317");
        }
        client21: StandardHost2 {
            parameters:
                @display("p=1160,260");
        }
        routerCore4: SplitTCPRouter {
            parameters:
                @display("p=828,128;i=abstract/router");
        }
        client15: StandardHost2 {
            parameters:
                @display("p=594,317");
        }
        client25: StandardHost2 {
            parameters:
                @display("p=888,260");
        }
        routerCore5: SplitTCPRouter {
            parameters:
                @display("p=999,119;i=abstract/router");
        }
        client16: StandardHost2 {
            parameters:
                @display("p=789,317");
        }
        client26: StandardHost2 {
            parameters:
                @display("p=999,260");
        }
        client111: StandardHost2 {
            parameters:
                @display("p=117,317");
        }
        client112: StandardHost2 {
            parameters:
                @display("p=117,366");
        }
        client113: StandardHost2 {
            parameters:
                @display("p=117,420");
        }
        client114: StandardHost2 {
            parameters:
                @display("p=117,473");
        }
        client115: StandardHost2 {
            parameters:
                @display("p=117,524");
        }
        client116: StandardHost2 {
            parameters:
                @display("p=117,574");
        }
        client117: StandardHost2 {
            parameters:
                @display("p=117,626");
        }
        client118: StandardHost2 {
            parameters:
                @display("p=117,678");
        }
        client119: StandardHost2 {
            parameters:
                @display("p=117,733");
        }
        client1110: StandardHost2 {
            parameters:
                @display("p=117,792");
        }
        client1111: StandardHost2 {
            parameters:
                @display("p=117,837");
        }
        client1112: StandardHost2 {
            parameters:
                @display("p=117,886");
        }
        client1113: StandardHost2 {
            parameters:
                @display("p=117,934");
        }
        client1114: StandardHost2 {
            parameters:
                @display("p=117,986");
        }
        client1115: StandardHost2 {
            parameters:
                @display("p=63,260");
        }
        client1116: StandardHost2 {
            parameters:
                @display("p=63,317");
        }
        client1117: StandardHost2 {
            parameters:
                @display("p=63,366");
        }
        client1118: StandardHost2 {
            parameters:
                @display("p=63,420");
        }
        client1119: StandardHost2 {
            parameters:
                @display("p=63,473");
        }
        client1120: StandardHost2 {
            parameters:
                @display("p=63,524");
        }
        client1121: StandardHost2 {
            parameters:
                @display("p=63,574");
        }
        client1122: StandardHost2 {
            parameters:
                @display("p=63,626");
        }
        client1123: StandardHost2 {
            parameters:
                @display("p=63,678");
        }
        client1124: StandardHost2 {
            parameters:
                @display("p=63,733");
        }
        client1125: StandardHost2 {
            parameters:
                @display("p=63,786");
        }
        client1126: StandardHost2 {
            parameters:
                @display("p=63,837");
        }
        client1127: StandardHost2 {
            parameters:
                @display("p=63,886");
        }
        client1128: StandardHost2 {
            parameters:
                @display("p=63,934");
        }
        client1129: StandardHost2 {
            parameters:
                @display("p=63,986");
        }
        client121: StandardHost2 {
            parameters:
                @display("p=183,366");
        }
        client122: StandardHost2 {
            parameters:
                @display("p=183,420");
        }
        client123: StandardHost2 {
            parameters:
                @display("p=183,473");
        }
        client124: StandardHost2 {
            parameters:
                @display("p=183,524");
        }
        client125: StandardHost2 {
            parameters:
                @display("p=183,574");
        }
        client126: StandardHost2 {
            parameters:
                @display("p=183,626");
        }
        client127: StandardHost2 {
            parameters:
                @display("p=183,678");
        }
        client131: StandardHost2 {
            parameters:
                @display("p=252,366");
        }
        client132: StandardHost2 {
            parameters:
                @display("p=252,420");
        }
        client133: StandardHost2 {
            parameters:
                @display("p=252,473");
        }
        client134: StandardHost2 {
            parameters:
                @display("p=252,524");
        }
        client135: StandardHost2 {
            parameters:
                @display("p=252,574");
        }
        client136: StandardHost2 {
            parameters:
                @display("p=252,626");
        }
        client137: StandardHost2 {
            parameters:
                @display("p=252,678");
        }
        client221: StandardHost2 {
            parameters:
                @display("p=335,317");
        }
        client222: StandardHost2 {
            parameters:
                @display("p=335,366");
        }
        client223: StandardHost2 {
            parameters:
                @display("p=335,420");
        }
        client224: StandardHost2 {
            parameters:
                @display("p=335,473");
        }
        client225: StandardHost2 {
            parameters:
                @display("p=335,524");
        }
        client226: StandardHost2 {
            parameters:
                @display("p=335,574");
        }
        client227: StandardHost2 {
            parameters:
                @display("p=335,626");
        }
        client141: StandardHost2 {
            parameters:
                @display("p=407,366");
        }
        client142: StandardHost2 {
            parameters:
                @display("p=407,420");
        }
        client143: StandardHost2 {
            parameters:
                @display("p=407,473");
        }
        client144: StandardHost2 {
            parameters:
                @display("p=407,524");
        }
        client145: StandardHost2 {
            parameters:
                @display("p=407,574");
        }
        client146: StandardHost2 {
            parameters:
                @display("p=407,626");
        }
        client147: StandardHost2 {
            parameters:
                @display("p=407,678");
        }
        client231: StandardHost2 {
            parameters:
                @display("p=495,317");
        }
        client232: StandardHost2 {
            parameters:
                @display("p=495,366");
        }
        client233: StandardHost2 {
            parameters:
                @display("p=495,420");
        }
        client234: StandardHost2 {
            parameters:
                @display("p=495,473");
        }
        client235: StandardHost2 {
            parameters:
                @display("p=495,524");
        }
        client236: StandardHost2 {
            parameters:
                @display("p=495,574");
        }
        client237: StandardHost2 {
            parameters:
                @display("p=495,626");
        }
        client151: StandardHost2 {
            parameters:
                @display("p=594,366");
        }
        client152: StandardHost2 {
            parameters:
                @display("p=594,420");
        }
        client153: StandardHost2 {
            parameters:
                @display("p=594,473");
        }
        client154: StandardHost2 {
            parameters:
                @display("p=594,524");
        }
        client155: StandardHost2 {
            parameters:
                @display("p=594,574");
        }
        client156: StandardHost2 {
            parameters:
                @display("p=594,626");
        }
        client157: StandardHost2 {
            parameters:
                @display("p=594,678");
        }
        client241: StandardHost2 {
            parameters:
                @display("p=673,317");
        }
        client242: StandardHost2 {
            parameters:
                @display("p=673,366");
        }
        client243: StandardHost2 {
            parameters:
                @display("p=673,420");
        }
        client244: StandardHost2 {
            parameters:
                @display("p=673,473");
        }
        client245: StandardHost2 {
            parameters:
                @display("p=673,524");
        }
        client246: StandardHost2 {
            parameters:
                @display("p=673,574");
        }
        client247: StandardHost2 {
            parameters:
                @display("p=673,626");
        }
        client161: StandardHost2 {
            parameters:
                @display("p=789,366");
        }
        client162: StandardHost2 {
            parameters:
                @display("p=789,420");
        }
        client163: StandardHost2 {
            parameters:
                @display("p=789,473");
        }
        client164: StandardHost2 {
            parameters:
                @display("p=789,524");
        }
        client165: StandardHost2 {
            parameters:
                @display("p=789,574");
        }
        client166: StandardHost2 {
            parameters:
                @display("p=789,626");
        }
        client167: StandardHost2 {
            parameters:
                @display("p=789,678");
        }
        client251: StandardHost2 {
            parameters:
                @display("p=888,317");
        }
        client252: StandardHost2 {
            parameters:
                @display("p=888,366");
        }
        client253: StandardHost2 {
            parameters:
                @display("p=888,420");
        }
        client254: StandardHost2 {
            parameters:
                @display("p=888,473");
        }
        client255: StandardHost2 {
            parameters:
                @display("p=888,524");
        }
        client256: StandardHost2 {
            parameters:
                @display("p=888,574");
        }
        client257: StandardHost2 {
            parameters:
                @display("p=888,626");
        }
        client261: StandardHost2 {
            parameters:
                @display("p=999,317");
        }
        client262: StandardHost2 {
            parameters:
                @display("p=999,366");
        }
        client263: StandardHost2 {
            parameters:
                @display("p=999,420");
        }
        client264: StandardHost2 {
            parameters:
                @display("p=999,473");
        }
        client265: StandardHost2 {
            parameters:
                @display("p=999,524");
        }
        client266: StandardHost2 {
            parameters:
                @display("p=999,574");
        }
        client267: StandardHost2 {
            parameters:
                @display("p=999,626");
        }
        client211: StandardHost2 {
            parameters:
                @display("p=1153,317");
        }
        client212: StandardHost2 {
            parameters:
                @display("p=1153,366");
        }
        client213: StandardHost2 {
            parameters:
                @display("p=1153,420");
        }
        client214: StandardHost2 {
            parameters:
                @display("p=1153,473");
        }
        client215: StandardHost2 {
            parameters:
                @display("p=1153,524");
        }
        client216: StandardHost2 {
            parameters:
                @display("p=1153,574");
        }
        client217: StandardHost2 {
            parameters:
                @display("p=1153,626");
        }
        client218: StandardHost2 {
            parameters:
                @display("p=1153,678");
        }
        client219: StandardHost2 {
            parameters:
                @display("p=1153,733");
        }
        client2110: StandardHost2 {
            parameters:
                @display("p=1153,792");
        }
        client2111: StandardHost2 {
            parameters:
                @display("p=1153,837");
        }
        client2112: StandardHost2 {
            parameters:
                @display("p=1153,886");
        }
        client2113: StandardHost2 {
            parameters:
                @display("p=1153,934");
        }
        client2114: StandardHost2 {
            parameters:
                @display("p=1153,986");
        }
        client2115: StandardHost2 {
            parameters:
                @display("p=1099,260");
        }
        client2116: StandardHost2 {
            parameters:
                @display("p=1099,317");
        }
        client2117: StandardHost2 {
            parameters:
                @display("p=1099,366");
        }
        client2118: StandardHost2 {
            parameters:
                @display("p=1099,420");
        }
        client2119: StandardHost2 {
            parameters:
                @display("p=1099,473");
        }
        client2120: StandardHost2 {
            parameters:
                @display("p=1099,524");
        }
        client2121: StandardHost2 {
            parameters:
                @display("p=1099,574");
        }
        client2122: StandardHost2 {
            parameters:
                @display("p=1099,626");
        }
        client2123: StandardHost2 {
            parameters:
                @display("p=1099,678");
        }
        client2124: StandardHost2 {
            parameters:
                @display("p=1099,733");
        }
        client2125: StandardHost2 {
            parameters:
                @display("p=1099,786");
        }
        client2126: StandardHost2 {
            parameters:
                @display("p=1099,837");
        }
        client2127: StandardHost2 {
            parameters:
                @display("p=1099,886");
        }
        client2128: StandardHost2 {
            parameters:
                @display("p=1099,934");
        }
        client2129: StandardHost2 {
            parameters:
                @display("p=1099,986");
        }
    connections:
        routerCore.pppg++ <--> NormalP <--> client11.pppg++;
        routerCore.pppg++ <--> NormalP <--> client12.pppg++;
        routerCore2.pppg++ <--> NormalP <--> client23.pppg++;
        routerCore.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client22.pppg++ <--> NormalP <--> routerCore1.pppg++;
        routerCore1.pppg++ <--> NormalP <--> routerCore2.pppg++;
        routerCore2.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client13.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client14.pppg++ <--> NormalP <--> routerCore2.pppg++;
        routerCore3.pppg++ <--> NormalP <--> client24.pppg++;
        routerCore3.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client15.pppg++ <--> NormalP <--> routerCore3.pppg++;
        routerCore4.pppg++ <--> NormalP <--> client25.pppg++;
        routerCore4.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client16.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client26.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client21.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client1115.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1116.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1117.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1118.pppg++ <--> NormalP <--> routerCore.pppg++;
        client111.pppg++ <--> NormalP <--> routerCore.pppg++;
        client112.pppg++ <--> NormalP <--> routerCore.pppg++;
        client113.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1119.pppg++ <--> NormalP <--> routerCore.pppg++;
        client114.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1120.pppg++ <--> NormalP <--> routerCore.pppg++;
        client115.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1121.pppg++ <--> NormalP <--> routerCore.pppg++;
        client116.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1122.pppg++ <--> NormalP <--> routerCore.pppg++;
        client117.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1123.pppg++ <--> NormalP <--> routerCore.pppg++;
        client118.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1124.pppg++ <--> NormalP <--> routerCore.pppg++;
        client119.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1125.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1110.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1126.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1111.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1127.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1112.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1128.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1113.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1129.pppg++ <--> NormalP <--> routerCore.pppg++;
        client1114.pppg++ <--> NormalP <--> routerCore.pppg++;
        client121.pppg++ <--> NormalP <--> routerCore.pppg++;
        client122.pppg++ <--> NormalP <--> routerCore.pppg++;
        client123.pppg++ <--> NormalP <--> routerCore.pppg++;
        client124.pppg++ <--> NormalP <--> routerCore.pppg++;
        client125.pppg++ <--> NormalP <--> routerCore.pppg++;
        client126.pppg++ <--> NormalP <--> routerCore.pppg++;
        client127.pppg++ <--> NormalP <--> routerCore.pppg++;
        client131.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client132.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client133.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client134.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client135.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client136.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client137.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client221.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client222.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client223.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client224.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client225.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client226.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client227.pppg++ <--> NormalP <--> routerCore1.pppg++;
        client141.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client142.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client143.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client144.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client145.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client146.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client147.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client231.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client232.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client233.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client234.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client235.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client236.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client237.pppg++ <--> NormalP <--> routerCore2.pppg++;
        client151.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client152.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client153.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client154.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client155.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client156.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client157.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client241.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client242.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client243.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client244.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client245.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client246.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client247.pppg++ <--> NormalP <--> routerCore3.pppg++;
        client161.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client162.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client163.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client164.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client165.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client166.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client167.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client251.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client252.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client253.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client254.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client255.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client256.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client257.pppg++ <--> NormalP <--> routerCore4.pppg++;
        client261.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client262.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client263.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client264.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client265.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client266.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client267.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2115.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2116.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client211.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2117.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client212.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2118.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client213.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2119.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client214.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2120.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client215.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2121.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client216.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2122.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client217.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2123.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client218.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2124.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client219.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2125.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2110.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2111.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2126.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2112.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2127.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2113.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2128.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2114.pppg++ <--> NormalP <--> routerCore5.pppg++;
        client2129.pppg++ <--> NormalP <--> routerCore5.pppg++;
}
