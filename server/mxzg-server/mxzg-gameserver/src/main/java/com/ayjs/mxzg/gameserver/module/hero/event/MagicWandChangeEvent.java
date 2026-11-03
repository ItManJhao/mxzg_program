package com.ayjs.mxzg.gameserver.module.hero.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import lombok.Value;

/**
 * 英雄魔杖卸下事件
 */
@Value(staticConstructor = "of")
public class MagicWandChangeEvent {
    long rid;

    long heroId;

    GameEvent gameEvent;
}
