package com.ayjs.mxzg.gameserver.module.adven.event;

import lombok.Value;

/**
 * 通关试炼事件
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class AdvenPassEvent {
    /**
     * 角色id
     */
    private long rid;
    /**
     * 配置idx
     */
    private int idx;
    /**
     * 输赢
     */
    private boolean isWin;

    /**
     * 挑战关卡
     */
    private int battleMissionId;
}
