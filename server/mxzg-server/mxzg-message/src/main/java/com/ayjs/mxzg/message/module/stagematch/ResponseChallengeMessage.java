package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 请求匹配对手信息
 */
@Getter
@AllArgsConstructor
public class ResponseChallengeMessage implements LargeCrossMessage {

    /**
     * 请求匹配的玩家id
     */
    private long rid;
    /**
     * 服务器id
     */
    private int serverId;
    /**
     * 名称
     */
    private String name;
    /**
     * 跳过布阵
     */
    private boolean skipArray;
    /**
     * 战场vo
     */
    private String battleVo;
    /**
     * 流水号
     */
    private int serialNumber;

    public static ResponseChallengeMessage createOf(long rid, int serverId, String name, boolean skipArray, String battleVo, int serialNumber){
        return new ResponseChallengeMessage(rid, serverId, name, skipArray, battleVo, serialNumber);
    }

}
