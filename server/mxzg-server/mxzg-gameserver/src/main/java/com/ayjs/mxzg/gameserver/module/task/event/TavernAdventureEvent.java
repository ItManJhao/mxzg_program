package com.ayjs.mxzg.gameserver.module.task.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import lombok.Value;

/**
 * 冒险点数变动事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class TavernAdventureEvent {
    private long rid;
    private long addCount;//增加值
    private long costCount;//减少值
    private long afterAdventureCount;//变化后的总值
    private GameEvent event;
}
