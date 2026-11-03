package com.ayjs.mxzg.gameserver.module.rank.event;

import lombok.Value;

@Value(staticConstructor = "of")
public class DungeonRankEvent {
    public long rid;
    public int stage;
}
