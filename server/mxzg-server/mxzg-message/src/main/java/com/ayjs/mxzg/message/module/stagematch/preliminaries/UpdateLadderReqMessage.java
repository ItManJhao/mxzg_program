package com.ayjs.mxzg.message.module.stagematch.preliminaries;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 战斗结束，替换双方排名
 */
@Getter
@Setter
public class UpdateLadderReqMessage implements LargeCrossMessage {
    /**
     * 赢方rid
     */
    private long winRid;
    /**
     * 赢方旧排名
     */
    private int winOldRank;
    /**
     * 败方Rid
     */
    private long loseRid;
    /**
     * 败方旧排名
     */
    private int loseOldRank;
}
