package com.ayjs.mxzg.gameserver.module.role.event;

import lombok.Value;

import java.time.LocalDateTime;

@Value(staticConstructor = "of")
public class BuryingPointEvent {

    long rid;
    // 指引表的idx
    int idx;

    LocalDateTime lastGuideTime;

}
