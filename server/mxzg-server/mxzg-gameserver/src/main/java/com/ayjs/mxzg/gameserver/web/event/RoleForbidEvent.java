package com.ayjs.mxzg.gameserver.web.event;

import lombok.Value;

import java.util.Set;

/**
 * 封号事件
 */
@Value(staticConstructor = "of")
public class RoleForbidEvent {
    /**
     * 被封号的玩家列表
     */
    private Set<Long> rids;
    /**
     * 封号结束时间
     */
    private int forbidEndTime;
}
