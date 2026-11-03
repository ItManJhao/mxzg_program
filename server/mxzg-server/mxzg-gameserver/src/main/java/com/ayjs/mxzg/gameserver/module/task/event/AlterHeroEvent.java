package com.ayjs.mxzg.gameserver.module.task.event;

import lombok.Value;

/**
 * 英雄献祭
 */
@Value(staticConstructor = "of")
public class AlterHeroEvent {
    private long rid;
    private int count;
}
