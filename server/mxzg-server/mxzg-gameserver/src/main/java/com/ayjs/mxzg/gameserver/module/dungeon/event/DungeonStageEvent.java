package com.ayjs.mxzg.gameserver.module.dungeon.event;

import lombok.Value;

/**
 * 庇护所塔层改变事件
 */
@Value(staticConstructor = "of")
public class DungeonStageEvent {
    private long rid;
    private int stage;

    public long getRid() {
        return rid;
    }

    public int getStage() {
        return stage;
    }
}
