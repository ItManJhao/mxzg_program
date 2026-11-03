package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event;

import lombok.Value;

/**
 * 航行结束事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class SailingEndEvent {
    private long rid;
}
