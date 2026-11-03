package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 请求挑战信息
 */
@Getter
@AllArgsConstructor
public class ChallengeReqMessage implements LargeCrossMessage {

    /**
     * 请求匹配的玩家id
     */
    private long rid;

    /**
     * 流水号
     */
    private int serialNumber;

    /**
     * 战斗vo
     */
    private String battlerVo;

    /**
     * 战力
     */
    private int fighting;

    public static ChallengeReqMessage createOf(long rid,int serialNumber, String battlerVo, int fighting){
        return new ChallengeReqMessage(rid, serialNumber, battlerVo, fighting);
    }

}
