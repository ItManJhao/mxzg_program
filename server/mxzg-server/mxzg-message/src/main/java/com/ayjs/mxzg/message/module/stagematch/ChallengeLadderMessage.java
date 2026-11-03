package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 挑战天梯
 */
@Getter
@AllArgsConstructor
public class ChallengeLadderMessage implements LargeCrossMessage {
    /**
     * 挑战天梯
     */
    private long rId;
    /**
     * 对手id
     */
    private long opponentId;
    /**
     * 对手的排名
     */
    private int rank;

    public static ChallengeLadderMessage createOf(long rId, long opponentId, int rank){
        return new ChallengeLadderMessage(rId, opponentId, rank);
    }

}
