package com.ayjs.mxzg.message.module.stagematch.preliminaries;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Value;


@Value(staticConstructor = "of")
public class PreliminariesSuperiorBattleMessage implements LargeCrossMessage {
    /***
     * 攻击方旧排名
     */
    private int attackRank;
    /***
     * 防守方旧排名
     */
    private int defendRank;
    /***
     * 战报
     */
    private byte[] battleReport;

}
