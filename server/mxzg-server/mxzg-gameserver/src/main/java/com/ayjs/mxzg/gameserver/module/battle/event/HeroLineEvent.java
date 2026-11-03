package com.ayjs.mxzg.gameserver.module.battle.event;

import com.ayjs.mxzg.config.struct.LineUpType;
import lombok.Value;

/**
 * 英雄布阵事件
 * @hyx
 */
@Value(staticConstructor = "of")
public class HeroLineEvent {
    private long rid;
    private LineUpType lineUpType;
}
