package com.ayjs.mxzg.gameserver.module.battle.event;

import lombok.Value;

/**
 * 关卡通关事件
 */
@Value(staticConstructor = "of")
public class ChapterPassEvent {
    private long rid;
    private int missionId;
}
