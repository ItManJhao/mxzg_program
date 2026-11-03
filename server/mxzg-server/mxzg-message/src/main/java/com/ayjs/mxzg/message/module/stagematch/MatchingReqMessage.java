package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 请求匹配对手信息
 */
@Getter
@AllArgsConstructor
public class MatchingReqMessage implements LargeCrossMessage {

    /**
     * 请求匹配的玩家id
     */
    private long rid;
    /**
     * 跳过布阵
     */
    private boolean skipArray;
    /**
     * 战场vo
     */
    private String battleVo;
    /**
     * 战力
     */
    private int fighting;
    /**
     * 头像
     */
    private int headId;
    /**
     * 头像框
     */
    private int borderId;

    public static MatchingReqMessage createOf(long rid, boolean skipArray, String battleVo, int fighting, int headId, int borderId){
        return new MatchingReqMessage(rid, skipArray, battleVo, fighting, headId, borderId);
    }

}
