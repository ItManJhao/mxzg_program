package com.ayjs.mxzg.message.module.ladder.message;

import lombok.Getter;
import lombok.Setter;

/**
 * 跨服天梯信息
 */
@Getter
@Setter
public class LadderDefenderData {
    /**
     * 有真人，和机器人id
     */
    private long rid;
    /**
     * 等级
     */
    private int level;
    /**
     * 头像
     */
    private int headId;
    /**
     * 头像框
     */
    private int borderId;
    /**
     * 形象
     */
    private int imageId;
    /**
     * 排名
     */
    private int rank;
    /**
     * 昵称
     */
    private String nick;
    /**
     * 服务id
     */
    private int serverId;
    /**
     * 公会名
     */
    private String clanName;
    /**
     * 战力
     */
    private int fighting;
    /**
     * 是否机器人，false机器人，true真人
     */
    private boolean realPlayer;
}
