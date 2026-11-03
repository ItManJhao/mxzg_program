package com.ayjs.mxzg.message.module.stagematch;

import com.ayjs.mxzg.message.largecross.LargeCrossMessage;
import lombok.Getter;
import lombok.Setter;

/**
 * 报告信息
 */
@Getter
@Setter
public class ReportOpponentMessage implements LargeCrossMessage {

    /**
     * 玩家id
     */
    private long rid;
    /**
     * 分区id
     */
    private int serverId;
    /**
     * 昵称
     */
    private String name;
    /**
     * 形象id
     */
    private int imageId;
    /**
     * 战斗vo
     */
    private String battlerVo;
    /**
     * 战力
     */
    private int fighting;
    /**
     * 等级
     */
    private int level;


    public static ReportOpponentMessage createOf(long rid, int serverId, String name, int imageId, String battlerVo, int fighting, int level){
        ReportOpponentMessage message = new ReportOpponentMessage();
        message.setRid(rid);
        message.setServerId(serverId);
        message.setName(name);
        message.setImageId(imageId);
        message.setBattlerVo(battlerVo);
        message.setFighting(fighting);
        message.setLevel(level);
        return message;
    }
}
