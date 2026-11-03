package com.ayjs.mxzg.gameserver.module.backpack.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import lombok.Value;

/**
 * 物品奖励事件
 */
@Value(staticConstructor = "of")
public class ThingAddEvent {
    /**
     * 角色id
     */
    private long rid;
    /**
     * 奖励信息
     */
    private Rewards rewards;
    /**
     * 事件来源
     */
    private GameEvent gameEvent;
    /**
     * 是否通知
     */
    private NoticeType notify;
}
