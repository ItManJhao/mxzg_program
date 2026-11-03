package com.ayjs.mxzg.gameserver.module.dailydungeon.constant;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DailyDungeonModel {
    /**
     * 已通关的最大关卡
     */
    private int passMaxMission;
    /**
     * 攻打次数
     */
    private int battleNum;
    /**
     * 刷新时间
     */
    private int refreshTime;
}
