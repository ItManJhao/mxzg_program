package com.ayjs.mxzg.gameserver.module.role.event;

import lombok.Value;

/**
 * 统计在线人数事件
 */
@Value(staticConstructor = "of")
public class StatisticsOnlineEvent {
    /**
     * 在线人数
     */
    private int onlineNum;

    /**
     * 去重在线人数
     */
    private int distinctOnlineNum;

    /**
     * 时间
     */
    private int time;
}
