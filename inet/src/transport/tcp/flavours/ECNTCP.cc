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
#include "ECNTCP.h"
#include "TCP.h"


Register_Class(ECNTCP);


ECNTCP::ECNTCP() : TCPTahoeRenoFamily(),
        state((TCPRenoStateVariables *&)TCPAlgorithm::state)
{
}

void ECNTCP::recalculateSlowStartThreshold()
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

void ECNTCP::processRexmitTimer(TCPEventCode& event)
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

void ECNTCP::processRateUpdateTimer(TCPEventCode& event)
{

    if(state->ecnnum_pacing) {
        TCPTahoeRenoFamily::processRateUpdateTimer(event);

        conn->scheduleRateUpdate(rateUpdateTimer, 0.00048);
    }

    if(state->ecnnum_cntr == 0) {
        state->ecnnum_maxRate = conn->tcpMain->par("ldatarate");

        double d = conn->tcpMain->par("param1");
        if(d != 0.0)
            state->ecnnum_alpha = d;

        d = conn->tcpMain->par("param2");
        if(d != 0.0)
            state->ecnnum_phi = d;

        state->ecnnum_Rate = (state->snd_cwnd * 8 / (double)state->minrtt.dbl()) / 1000 / state->snd_mss / 8;
        if (rateVector && simTime() >= conn->tcpMain->par("param3"))
            rateVector->record(state->ecnnum_Rate);

        state->ecnnum_cntr++;
    }

    simtime_t now1 = simTime();

    state->ecnnum_fraction = state->ecnnum_alpha * state->dctcp_marked / state->dctcp_total + (1 - state->ecnnum_alpha) * state->ecnnum_fraction;

    if (loadVector)
        loadVector->record(state->dctcp_marked / state->dctcp_total);
    if (calcLoadVector)
        calcLoadVector->record(state->ecnnum_fraction);

//    if(newCwnd * 8 / (double)state->minrtt.dbl() > state->ecnnum_maxRate) {
//            newCwnd = state->ecnnum_maxRate / 8 * (double)state->minrtt.dbl();
//    }


//    if(state->ecnnum_fraction == 0) {
////        newCwnd += state->snd_mss;
////        state->ecnnum_Rate += (newCwnd * 8 / (double)state->minrtt.dbl()) / 1000 / state->snd_mss / 8;
//        state->ecnnum_Rate++;
//
//    } else
        if(state->dctcp_marked / state->dctcp_total == 1) {
//        newCwnd /= 1.1;
//        state->ecnnum_Rate = (newCwnd * 8 / (double)state->minrtt.dbl()) / 1000 / state->snd_mss / 8;
        state->ecnnum_Rate /= 1.1; // 1.5
        state->ecnnum_fraction = 1 - pow(1 - state->ecnnum_fraction, 1.1);
    } else
    {
        double q = state->ecnnum_fraction;//( -std::log(1-state->ecnnum_fraction)  / std::log(state->ecnnum_phi)); //
//        double q = state->ecnnum_fraction; //
        if(q == 0 || (1 / q ) > 1.2 * state->ecnnum_Rate)
            state->ecnnum_Rate *= 1.2;
        else
            state->ecnnum_Rate = (1 / q );
//        state->ecnnum_Rate = state->ecnnum_alpha * (1 / state->ecnnum_Rate - q ) + state->ecnnum_Rate;
    }

    if(state->ecnnum_Rate <= 0)
        state->ecnnum_Rate = 0.01;

    if(state->ecnnum_Rate * state->snd_mss * 8 * 1000 > state->ecnnum_maxRate) {
        state->ecnnum_Rate = state->ecnnum_maxRate / 1000 / state->snd_mss / 8;
    }

    uint32 newCwnd = state->snd_cwnd;
    newCwnd = state->snd_mss * state->ecnnum_Rate * (double)state->minrtt.dbl() / 0.001;
    newCwnd = round(newCwnd / state->snd_mss) * state->snd_mss;
    if(newCwnd < state->snd_mss)
        newCwnd = state->snd_mss;

//    uint32 rCwnd = newCwnd / state->snd_mss;
//    if(rCwnd * state->snd_mss < newCwnd) {
//        newCwnd = (rCwnd + 1) * state->snd_mss;
////        state->ecnnum_Rate = (newCwnd * 8 / (double)state->minrtt.dbl()) / 1000 / state->snd_mss / 8;
//    }

//    if(newCwnd < 2 * state->snd_mss) {
//        if(newCwnd * 1.5 < 2 * state->snd_mss)
//            newCwnd *= 1.5;
//        else
//            newCwnd = 2 * state->snd_mss;
//        state->ecnnum_Rate = (newCwnd * 8 / (double)state->minrtt.dbl()) / 1000 / state->snd_mss / 8;
//    }

    state->snd_cwnd = newCwnd;

    if (cwndVector)
        cwndVector->record(state->snd_cwnd);
    if (rateVector && simTime() >= conn->tcpMain->par("param3"))
        rateVector->record(state->ecnnum_Rate);

    state->ecnnum_lastCalcTime = now1;

    state->dctcp_marked = 0;
    state->dctcp_total = 0;

    if(state->ecnnum_pacing) {
        double minRTT = (double)state->minrtt.dbl();
        double totalSpace = minRTT - (8 * (double)state->snd_cwnd / state->ecnnum_maxRate);
        state->interPacketSpace = totalSpace / (state->snd_cwnd / state->snd_mss);
        if(!state->lgcc_sch) {
            conn->schedulePace(paceTimer, exponential(state->interPacketSpace));
            state->lgcc_sch = true;
        }
        if (interPSpaceVector)
            interPSpaceVector->record(state->interPacketSpace);
    }
}

void ECNTCP::processPaceTimer(TCPEventCode& event)
{
    TCPTahoeRenoFamily::processPaceTimer(event);

    uint32 cwnd = state->snd_cwnd;
    if(state->snd_cwnd >= (state->snd_nxt - state->snd_una) + 2 * state->snd_mss)
        state->snd_cwnd = state->snd_mss + (state->snd_nxt - state->snd_una);

//    if(state->snd_cwnd < (state->snd_nxt - state->snd_una) + 1 * state->snd_mss)
//            state->snd_cwnd = state->snd_mss + (state->snd_nxt - state->snd_una);

    sendData(false);

    state->snd_cwnd = cwnd;
    conn->schedulePace(paceTimer, exponential(state->interPacketSpace));
}

void ECNTCP::receivedDataAck(uint32 firstSeqAcked)
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
//---------------ECN NUM
        state->dctcp_total++;
        if(state->ece) {
            state->dctcp_marked++;
            markingProb->record(1);
        } else
            markingProb->record(0);

        if(state->ecnnum_pacing) {
            if(!state->lgcc_sch_rate) {
                state->lgcc_sch_rate = true;
                TCPEventCode event = TCP_E_IGNORE;
                processRateUpdateTimer(event);
                //conn->scheduleRateUpdate(rateUpdateTimer, 0.000140);
            }
            return;
        } else {
            simtime_t now1 = simTime();

            if((now1 - state->ecnnum_lastCalcTime >= state->minrtt * 1)) {// state->minrtt * 1
                TCPEventCode event = TCP_E_IGNORE;
                processRateUpdateTimer(event);
            }
        }
//---------------End - ECN NUM

    }

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

void ECNTCP::receivedDuplicateAck()
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
