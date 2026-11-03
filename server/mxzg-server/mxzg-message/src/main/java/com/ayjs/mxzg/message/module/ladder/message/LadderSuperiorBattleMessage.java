package com.ayjs.mxzg.message.module.ladder.message;

import com.ayjs.mxzg.message.cross.CrossMessage;
import lombok.Value;

/**
 * 大神战斗
 *
 * @Author: CWJ
 * @Date: 2020/1/4
 **/
@Value(staticConstructor = "of")
public class LadderSuperiorBattleMessage implements CrossMessage {
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
