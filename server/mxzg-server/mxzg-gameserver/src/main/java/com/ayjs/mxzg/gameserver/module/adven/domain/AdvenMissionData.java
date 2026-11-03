package com.ayjs.mxzg.gameserver.module.adven.domain;

import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import lombok.Data;

/**
 * 英雄试炼单个关卡数据
 */
@Data
public class AdvenMissionData {

    /**
     * 关卡ID
     */
    private int missionId;
    /**
     * 关卡状态值，0，没通关/没领奖，1已通关/已领奖
     */
    private byte state;
    /**
     * 防守方rid
     */
    private long defRid;
    /**
     * 防守方名字
     */
    private String defNick;
    /**
     * 防守方类型，0未设置，1机器人，2，真实玩家
     */
    private byte defType;
    /**
     * 战力
     */
    private long fighting;
    /**
     * 防守方法等级
     */
    private int defLevel;
    /**
     * 防守方头像
     */
    private int defHeadId;
    /**
     * 防守方战斗数据
     */
    private BattlerVo battlerVo;

    public boolean isRobot() {
        return defType == 1;
    }

    public boolean isRealRole() {
        return defType == 2;
    }

}
