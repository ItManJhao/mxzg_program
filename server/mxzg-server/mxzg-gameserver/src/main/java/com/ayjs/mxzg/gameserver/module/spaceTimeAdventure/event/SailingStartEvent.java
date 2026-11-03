package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event;

import lombok.Value;

/**
 * 舰队启航事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class SailingStartEvent {
    private long rid;
}
