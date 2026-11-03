package com.ayjs.mxzg.gameserver.module.fetter.event;

import lombok.Value;

/**
 * 羁绊精炼事件
 */
@Value(staticConstructor = "of")
public class GoddessRefineEvent {
    private long rid;
    //新的精炼等级
    private int refine_level;
}
