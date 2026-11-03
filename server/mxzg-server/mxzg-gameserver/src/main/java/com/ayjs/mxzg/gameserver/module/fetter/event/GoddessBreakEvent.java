package com.ayjs.mxzg.gameserver.module.fetter.event;

import lombok.Value;

/**
 * 羁绊突破事件
 */
@Value(staticConstructor = "of")
public class GoddessBreakEvent {
    private long rid;
    //新的突破等级
    private int uplimit_level;
}
