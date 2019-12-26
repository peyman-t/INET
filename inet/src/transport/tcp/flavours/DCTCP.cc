//
// Copyright (C) 2004-2005 Andras Varga
// Copyright (C) 2009 Thomas Reschka
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program; if not, see <http://www.gnu.org/licenses/>.
//

#include <algorithm>   // min,max
#include "DCTCP.h"
#include "TCP.h"


Register_Class(DCTCP);


DCTCP::DCTCP() : TCPTahoeRenoFamily(),
        state((TCPRenoStateVariables *&)TCPAlgorithm::state)
{
}

void DCTCP::recalculateSlowStartThreshold()
{
    // RFC 2581, page 4:
    // "When a TCP sender detects segment loss using the retransmission
    // timer, the value of ssthresh MUST be set to no more than the value
    // given in equation 3:
    //
    //   ssthresh = max (FlightSize / 2, 2*SMSS)            (3)
    //
    // As discussed above, FlightSize is the amount of outstanding data in
    // the network."

    // set ssthresh to flight size / 2, but at least 2 SMSS
    // (the formula below practically amounts to ssthresh = cwnd / 2 most of the time)
    uint32 flight_size = std::min(state->snd_cwnd, state->snd_wnd); // FIXME TODO - Does this formula computes the amount of outstanding data?
    // uint32 flight_size = state->snd_max - state->snd_una;
    state->ssthresh = std::max(flight_size / 2, 2 * state->snd_mss);

    if (ssthreshVector)
        ssthreshVector->record(state->ssthresh);
}

void DCTCP::processRexmitTimer(TCPEventCode& event)
{
    TCPTahoeRenoFamily::processRexmitTimer(event);

    if (event == TCP_E_ABORT)
        return;

    // After REXMIT timeout TCP Reno should start slow start with snd_cwnd = snd_mss.
    //
    // If calling "retransmitData();" there is no rexmit limitation (bytesToSend > snd_cwnd)
    // therefore "sendData();" has been modified and is called to rexmit outstanding data.
    //
    // RFC 2581, page 5:
    // "Furthermore, upon a timeout cwnd MUST be set to no more than the loss
    // window, LW, which equals 1 full-sized segment (regardless of the
    // value of IW).  Therefore, after retransmitting the dropped segment
    // the TCP sender uses the slow start algorithm to increase the window
    // from 1 full-sized segment to the new value of ssthresh, at which
    // point congestion avoidance again takes over."

    // begin Slow Start (RFC 2581)
    recalculateSlowStartThreshold();
    state->snd_cwnd = state->snd_mss;

    if (cwndVector)
        cwndVector->record(state->snd_cwnd);

    tcpEV << "Begin Slow Start: resetting cwnd to " << state->snd_cwnd
          << ", ssthresh=" << state->ssthresh << "\n";

    state->afterRto = true;

    conn->retransmitOneSegment(true);
}

void DCTCP::processPaceTimer(TCPEventCode& event)
{
    TCPTahoeRenoFamily::processPaceTimer(event);

    uint32 cwnd = state->snd_cwnd;
    if(state->snd_cwnd >= (state->snd_nxt - state->snd_una) + 2 * state->snd_mss)
        state->snd_cwnd = state->snd_mss + (state->snd_nxt - state->snd_una);

    sendData(false);

    state->snd_cwnd = cwnd;
    conn->schedulePace(paceTimer, exponential(state->interPacketSpace));
}

void DCTCP::receivedDataAck(uint32 firstSeqAcked)
{
    TCPTahoeRenoFamily::receivedDataAck(firstSeqAcked);

    if (state->dupacks >= DUPTHRESH) // DUPTHRESH = 3
    {
        //
        // Perform Fast Recovery: set cwnd to ssthresh (deflating the window).
        //
        tcpEV << "Fast Recovery: setting cwnd to ssthresh=" << state->ssthresh << "\n";
        state->snd_cwnd = state->ssthresh;

        if (cwndVector)
            cwndVector->record(state->snd_cwnd);
    }
    else
    {
//---------------LGCC
//        state->dctcp_total++;
//        if(state->ece)
//            state->dctcp_marked++;
//
//        simtime_t now1 = simTime();
//
//        if((now1 - state->dctcp_lastCalcTime >= state->minrtt * 1)) {// state->minrtt * 1
//            if(state->lgcc_cntr == 0) {
//                state->lgcc_rate = state->snd_cwnd / (state->lgcc_phyRate * (double)state->minrtt.dbl() / 8);
//            }
//
//            for(int i = 0; i < state->lgcc_winSize - 1; i++) {
//                state->ecnmarked[i] = state->ecnmarked[i + 1];
//                state->total[i] = state->total[i + 1];
//            }
//            state->ecnmarked[state->lgcc_winSize - 1] = state->dctcp_marked;
//            state->total[state->lgcc_winSize - 1] =         state->dctcp_total;
//
//            double sumECN = 0, sumTotal = 0;
//            for(int i = 0; i < state->lgcc_winSize; i++) {
//                sumECN +=  state->ecnmarked[i];
//                sumTotal +=  state->total[i];
//            }
//            state->lgcc_calcLoad = sumECN / sumTotal;
////            state->lgcc_calcLoad = state->lgcc_gamma * (state->dctcp_marked / state->dctcp_total) + (1 - state->lgcc_gamma) * state->lgcc_calcLoad;
//            if (calcLoadVector)
//                calcLoadVector->record(state->lgcc_calcLoad);
//
//            state->lgcc_load = (state->ecnmarked[state->lgcc_winSize - 1]) /
//                    (state->total[state->lgcc_winSize - 1]);
////            state->lgcc_load = (state->ecnmarked[state->lgcc_winSize - 1] + state->ecnmarked[state->lgcc_winSize - 2]) /
////                    (state->total[state->lgcc_winSize - 1] + state->total[state->lgcc_winSize - 2]);
//            if (loadVector)
//                loadVector->record(state->lgcc_load);
//
//            double alphaTemp = state->lgcc_r;
//            bool setBack = false;
//
//            double expRate = (1 - state->lgcc_calcLoad);
//            if(state->lgcc_rate < expRate - 0.015 && expRate < 1) { //0.015
//                state->lgcc_r = ((expRate) - state->lgcc_rate) * 6.66;//2.5
//            } else if(state->lgcc_rate > expRate + 0.015) {
//                if((1 - state->lgcc_rate - state->lgcc_load) < 0)
//                {
//                    state->lgcc_r = (state->lgcc_rate - (expRate)) * 6.66;//2.5
//                    setBack = true;
//                }
//            } else if(expRate < 1)
//                state->lgcc_r = state->lgcc_rConv;
//
//            state->lgcc_r = std::max(std::min(state->lgcc_r, state->lgcc_rInit), state->lgcc_rConv);
//
//            if(state->lgcc_cntr <= 5) { // state->lgcc_winSize
//                if(state->dctcp_marked || state->lgcc_fnem) {
//                    state->lgcc_load = state->lgcc_calcLoad;
//                    state->lgcc_fnem = true;
//                } else {
//                    state->lgcc_load = 0;
//                }
//                state->lgcc_r = state->lgcc_rInit;
//                state->lgcc_cntr++;
//            }
////            if(state->lgcc_cntr <= 3) { //state->lgcc_maxWin / 80000
////                state->lgcc_load = 0;
////                state->lgcc_r = state->lgcc_rInit;
////                state->lgcc_cntr++;
////                if(state->dctcp_marked == state->dctcp_total)
////                    state->lgcc_fnem = true;
////            } else if(state->lgcc_cntr <= 6) {
////                if(state->dctcp_marked == state->dctcp_total && state->lgcc_fnem) {
////                    state->lgcc_load = state->lgcc_rate;
////                    state->lgcc_r = state->lgcc_rConv;
////                }
////                state->lgcc_cntr++;
////            }
//
////            state->lgcc_r = state->lgcc_rConv;
//            state->lgcc_rate = state->lgcc_rate * state->lgcc_r * (1 - state->lgcc_rate - state->lgcc_load) + state->lgcc_rate;
//
//            uint32 newCwnd = state->lgcc_rate * state->lgcc_phyRate * (double)state->minrtt.dbl() / 8;
//            if(newCwnd < 2 * state->snd_mss) {
//                if(newCwnd * 1.5 < 2 * state->snd_mss)
//                    newCwnd *= 1.5;
//                else
//                    newCwnd = 2 * state->snd_mss;
//                state->lgcc_rate = newCwnd / (state->lgcc_phyRate * (double)state->minrtt.dbl() / 8);
//            }
//
//            state->snd_cwnd = newCwnd;
//
//            if (cwndVector)
//                cwndVector->record(state->snd_cwnd);
//            if (brVector)
//                brVector->record(state->lgcc_r);
//
//            state->dctcp_lastCalcTime = now1;
//
//            if(setBack)
//                state->lgcc_r = alphaTemp;
//
//            state->dctcp_marked = 0;
//            state->dctcp_total = 0;
//
//            double minRTT = (double)state->minrtt.dbl();
//            double totalSpace = minRTT - (8 * (double)state->snd_cwnd / state->lgcc_phyRate);
//            state->interPacketSpace = totalSpace / (state->snd_cwnd / state->snd_mss);
//            if(!state->lgcc_sch) {
//                conn->schedulePace(paceTimer, exponential(state->interPacketSpace));
//                state->lgcc_sch = true;
//            }
//            if (interPSpaceVector)
//                interPSpaceVector->record(state->interPacketSpace);
//        }
//        return;
//
////goto l1;
//// Works!!!!!!!!!!!!!!!!!!!!!!!!!!!!
////        updateRate = true;
////        state->lgcc_cntr++;
////        if(state->ece) {
////            if(state->lgcc_cntr > 5 && state->lgcc_fnem)
////                state->lgcc_load = 0.25 * state->lgcc_load + 0.75 * 1;
////        } else {
////            state->lgcc_fnem = true;
////            state->lgcc_load = 0.25 * state->lgcc_load;
////        }
////        if (loadVector)
////            loadVector->record(state->lgcc_load);
////
////        if(updateRate) {//now - state->dctcp_lastCalcTime >= 1 * 0.048 &&
////            state->lgcc_rate = state->lgcc_rate + state->lgcc_rate * state->lgcc_r * (1 - state->lgcc_rate - state->lgcc_load);
////
////            uint32 newCwnd = state->lgcc_rate * state->lgcc_maxWin;
////            if(newCwnd < 2 * state->snd_mss) {
////                if(newCwnd * 1.5 < 2 * state->snd_mss)
////                    newCwnd *= 1.5;
////                else
////                    newCwnd = 2 * state->snd_mss;
////                state->lgcc_rate = newCwnd / state->lgcc_maxWin;
////            }
////            state->snd_cwnd = newCwnd;
////
////            if (cwndVector)
////                cwndVector->record(state->snd_cwnd);
////        }
//goto l2;
//------------------DCTCP
l1:
        state->dctcp_total++;

        if(state->ece) {
            state->dctcp_marked++;
            if (simTime() >= conn->tcpMain->par("param3"))
                markingProb->record(1);
        } else {
            if (simTime() >= conn->tcpMain->par("param3"))
                markingProb->record(0);
        }

        simtime_t now = simTime();
        bool cut = false;


        //if(now - state->dctcp_lastCalcTime >= state->minrtt) {
            if(firstSeqAcked >= state->dctcp_windEnd) {
                                        //            if(now - state->dctcp_lastCalcTime >= state->srtt) {
//            state->dctcp_alpha = (1 - state->dctcp_gamma) * state->dctcp_alpha + state->dctcp_gamma * (state->dctcp_marked / state->dctcp_total);
            double ratio = (state->dctcp_bytesMarked / state->dctcp_bytesAcked);

            if (loadVector && simTime() >= conn->tcpMain->par("param3"))
                    loadVector->record(ratio);

            double d = conn->tcpMain->par("param2");
            if(d > 0) {
                ratio = ( -log(1 - ratio)  / log(d));

                if(ratio > 1)
                    ratio = 1;
            }

            state->dctcp_alpha = (1 - state->dctcp_gamma) * state->dctcp_alpha + state->dctcp_gamma * ratio;

            if (calcLoadVector && simTime() >= conn->tcpMain->par("param3"))
                calcLoadVector->record(state->dctcp_alpha);

            if(state->dctcp_marked && state->dctcp_CWR == false)
                cut = true;

            state->dctcp_lastCalcTime = now;
            state->dctcp_marked = 0;
            state->dctcp_total = 0;

            state->dctcp_windEnd = state->snd_nxt;
            state->dctcp_bytesAcked = state->dctcp_bytesMarked = 0;
            state->dctcp_CWR = false;

        }

        if((state->dctcp_bytesMarked && !state->dctcp_CWR) ) {
//            if(cut || (state->dctcp_bytesMarked && !state->dctcp_CWR) ) {
            state->dctcp_CWR = true;

            state->snd_cwnd = state->snd_cwnd * (1 - state->dctcp_alpha / 2);
//            uint32 rCwnd = state->snd_cwnd / state->snd_mss;
//            if(rCwnd * state->snd_mss < state->snd_cwnd)
//                state->snd_cwnd = (rCwnd + 1) * state->snd_mss;

            uint32 flight_size = std::min(state->snd_cwnd, state->snd_wnd); // FIXME TODO - Does this formula computes the amount of outstanding data?
            state->ssthresh = std::max(3 * flight_size / 4, 2 * state->snd_mss);

            if (cwndVector && simTime() >= conn->tcpMain->par("param3"))
                cwndVector->record(state->snd_cwnd);
        } else {



            //
            // Perform slow start and congestion avoidance.
            //
            if (state->snd_cwnd < state->ssthresh)
            {
                tcpEV << "cwnd <= ssthresh: Slow Start: increasing cwnd by one SMSS bytes to ";

                // perform Slow Start. RFC 2581: "During slow start, a TCP increments cwnd
                // by at most SMSS bytes for each ACK received that acknowledges new data."
                state->snd_cwnd += state->snd_mss;

                // Note: we could increase cwnd based on the number of bytes being
                // acknowledged by each arriving ACK, rather than by the number of ACKs
                // that arrive. This is called "Appropriate Byte Counting" (ABC) and is
                // described in RFC 3465. This RFC is experimental and probably not
                // implemented in real-life TCPs, hence it's commented out. Also, the ABC
                // RFC would require other modifications as well in addition to the
                // two lines below.
                //
                // int bytesAcked = state->snd_una - firstSeqAcked;
                // state->snd_cwnd += bytesAcked * state->snd_mss;

                if (cwndVector && simTime() >= conn->tcpMain->par("param3"))
                    cwndVector->record(state->snd_cwnd);

                tcpEV << "cwnd=" << state->snd_cwnd << "\n";
            }
            else
            {
                // perform Congestion Avoidance (RFC 2581)
                uint32 incr = state->snd_mss * state->snd_mss / state->snd_cwnd;

                if (incr == 0)
                    incr = 1;

                state->snd_cwnd += incr;

                if (cwndVector && simTime() >= conn->tcpMain->par("param3"))
                    cwndVector->record(state->snd_cwnd);

                //
                // Note: some implementations use extra additive constant mss / 8 here
                // which is known to be incorrect (RFC 2581 p5)
                //
                // Note 2: RFC 3465 (experimental) "Appropriate Byte Counting" (ABC)
                // would require maintaining a bytes_acked variable here which we don't do
                //

                tcpEV << "cwnd > ssthresh: Congestion Avoidance: increasing cwnd linearly, to " << state->snd_cwnd << "\n";
            }
        }
    }


    if (rateVector)
        rateVector->record(state->snd_cwnd * 8 / (state->lastrtt));

l2:
    if (state->sack_enabled && state->lossRecovery)
    {
        // RFC 3517, page 7: "Once a TCP is in the loss recovery phase the following procedure MUST
        // be used for each arriving ACK:
        //
        // (A) An incoming cumulative ACK for a sequence number greater than
        // RecoveryPoint signals the end of loss recovery and the loss
        // recovery phase MUST be terminated.  Any information contained in
        // the scoreboard for sequence numbers greater than the new value of
        // HighACK SHOULD NOT be cleared when leaving the loss recovery
        // phase."
        if (seqGE(state->snd_una, state->recoveryPoint))
        {
            tcpEV << "Loss Recovery terminated.\n";
            state->lossRecovery = false;
        }
        // RFC 3517, page 7: "(B) Upon receipt of an ACK that does not cover RecoveryPoint the
        //following actions MUST be taken:
        //
        // (B.1) Use Update () to record the new SACK information conveyed
        // by the incoming ACK.
        //
        // (B.2) Use SetPipe () to re-calculate the number of octets still
        // in the network."
        else
        {
            // update of scoreboard (B.1) has already be done in readHeaderOptions()
            conn->setPipe();

            // RFC 3517, page 7: "(C) If cwnd - pipe >= 1 SMSS the sender SHOULD transmit one or more
            // segments as follows:"
            if (((int)state->snd_cwnd - (int)state->pipe) >= (int)state->snd_mss) // Note: Typecast needed to avoid prohibited transmissions
                conn->sendDataDuringLossRecoveryPhase(state->snd_cwnd);
        }
    }

    // RFC 3517, pages 7 and 8: "5.1 Retransmission Timeouts
    // (...)
    // If there are segments missing from the receiver's buffer following
    // processing of the retransmitted segment, the corresponding ACK will
    // contain SACK information.  In this case, a TCP sender SHOULD use this
    // SACK information when determining what data should be sent in each
    // segment of the slow start.  The exact algorithm for this selection is
    // not specified in this document (specifically NextSeg () is
    // inappropriate during slow start after an RTO).  A relatively
    // straightforward approach to "filling in" the sequence space reported
    // as missing should be a reasonable approach."
    sendData(false);
}

void DCTCP::receivedDuplicateAck()
{
    TCPTahoeRenoFamily::receivedDuplicateAck();

    if (state->dupacks == DUPTHRESH) // DUPTHRESH = 3
    {
        tcpEV << "Reno on dupAcks == DUPTHRESH(=3): perform Fast Retransmit, and enter Fast Recovery:";

        if (state->sack_enabled)
        {
            // RFC 3517, page 6: "When a TCP sender receives the duplicate ACK corresponding to
            // DupThresh ACKs, the scoreboard MUST be updated with the new SACK
            // information (via Update ()).  If no previous loss event has occurred
            // on the connection or the cumulative acknowledgment point is beyond
            // the last value of RecoveryPoint, a loss recovery phase SHOULD be
            // initiated, per the fast retransmit algorithm outlined in [RFC2581].
            // The following steps MUST be taken:
            //
            // (1) RecoveryPoint = HighData
            //
            // When the TCP sender receives a cumulative ACK for this data octet
            // the loss recovery phase is terminated."

            // RFC 3517, page 8: "If an RTO occurs during loss recovery as specified in this document,
            // RecoveryPoint MUST be set to HighData.  Further, the new value of
            // RecoveryPoint MUST be preserved and the loss recovery algorithm
            // outlined in this document MUST be terminated.  In addition, a new
            // recovery phase (as described in section 5) MUST NOT be initiated
            // until HighACK is greater than or equal to the new value of
            // RecoveryPoint."
            if (state->recoveryPoint == 0 || seqGE(state->snd_una, state->recoveryPoint)) // HighACK = snd_una
            {
                state->recoveryPoint = state->snd_max; // HighData = snd_max
                state->lossRecovery = true;
                tcpEV << " recoveryPoint=" << state->recoveryPoint;
            }
        }
        // RFC 2581, page 5:
        // "After the fast retransmit algorithm sends what appears to be the
        // missing segment, the "fast recovery" algorithm governs the
        // transmission of new data until a non-duplicate ACK arrives.
        // (...) the TCP sender can continue to transmit new
        // segments (although transmission must continue using a reduced cwnd)."

        // enter Fast Recovery
        recalculateSlowStartThreshold();
        // "set cwnd to ssthresh plus 3 * SMSS." (RFC 2581)
        state->snd_cwnd = state->ssthresh + 3 * state->snd_mss; // 20051129 (1)

//        if (cwndVector)
//            cwndVector->record(state->snd_cwnd);

        tcpEV << " set cwnd=" << state->snd_cwnd << ", ssthresh=" << state->ssthresh << "\n";

        // Fast Retransmission: retransmit missing segment without waiting
        // for the REXMIT timer to expire
        conn->retransmitOneSegment(false);

        // Do not restart REXMIT timer.
        // Note: Restart of REXMIT timer on retransmission is not part of RFC 2581, however optional in RFC 3517 if sent during recovery.
        // Resetting the REXMIT timer is discussed in RFC 2582/3782 (NewReno) and RFC 2988.

        if (state->sack_enabled)
        {
            // RFC 3517, page 7: "(4) Run SetPipe ()
            //
            // Set a "pipe" variable  to the number of outstanding octets
            // currently "in the pipe"; this is the data which has been sent by
            // the TCP sender but for which no cumulative or selective
            // acknowledgment has been received and the data has not been
            // determined to have been dropped in the network.  It is assumed
            // that the data is still traversing the network path."
            conn->setPipe();
            // RFC 3517, page 7: "(5) In order to take advantage of potential additional available
            // cwnd, proceed to step (C) below."
            if (state->lossRecovery)
            {
                // RFC 3517, page 9: "Therefore we give implementers the latitude to use the standard
                // [RFC2988] style RTO management or, optionally, a more careful variant
                // that re-arms the RTO timer on each retransmission that is sent during
                // recovery MAY be used.  This provides a more conservative timer than
                // specified in [RFC2988], and so may not always be an attractive
                // alternative.  However, in some cases it may prevent needless
                // retransmissions, go-back-N transmission and further reduction of the
                // congestion window."
                // Note: Restart of REXMIT timer on retransmission is not part of RFC 2581, however optional in RFC 3517 if sent during recovery.
                tcpEV << "Retransmission sent during recovery, restarting REXMIT timer.\n";
                restartRexmitTimer();

                // RFC 3517, page 7: "(C) If cwnd - pipe >= 1 SMSS the sender SHOULD transmit one or more
                // segments as follows:"
                if (((int)state->snd_cwnd - (int)state->pipe) >= (int)state->snd_mss) // Note: Typecast needed to avoid prohibited transmissions
                    conn->sendDataDuringLossRecoveryPhase(state->snd_cwnd);
            }
        }

        // try to transmit new segments (RFC 2581)
        sendData(false);
    }
    else if (state->dupacks > DUPTHRESH) // DUPTHRESH = 3
    {
        //
        // Reno: For each additional duplicate ACK received, increment cwnd by SMSS.
        // This artificially inflates the congestion window in order to reflect the
        // additional segment that has left the network
        //
        state->snd_cwnd += state->snd_mss;
        tcpEV << "Reno on dupAcks > DUPTHRESH(=3): Fast Recovery: inflating cwnd by SMSS, new cwnd=" << state->snd_cwnd << "\n";

//        if (cwndVector)
//            cwndVector->record(state->snd_cwnd);

        // Note: Steps (A) - (C) of RFC 3517, page 7 ("Once a TCP is in the loss recovery phase the following procedure MUST be used for each arriving ACK")
        // should not be used here!

        // RFC 3517, pages 7 and 8: "5.1 Retransmission Timeouts
        // (...)
        // If there are segments missing from the receiver's buffer following
        // processing of the retransmitted segment, the corresponding ACK will
        // contain SACK information.  In this case, a TCP sender SHOULD use this
        // SACK information when determining what data should be sent in each
        // segment of the slow start.  The exact algorithm for this selection is
        // not specified in this document (specifically NextSeg () is
        // inappropriate during slow start after an RTO).  A relatively
        // straightforward approach to "filling in" the sequence space reported
        // as missing should be a reasonable approach."
        sendData(false);
    }
}
