package com.ayjs.mxzg.gameserver.web.event;

import lombok.Value;

import java.util.Set;

/**
 * 禁言事件
 */
@Value(staticConstructor = "of")
public class RoleForbidChatEvent {

    /**
     * 被封号的玩家列表
     */
    private Set<Long> rids;
    /**
     * 禁言结束时间
     */
    private int forbidWordsEndTime;
}
