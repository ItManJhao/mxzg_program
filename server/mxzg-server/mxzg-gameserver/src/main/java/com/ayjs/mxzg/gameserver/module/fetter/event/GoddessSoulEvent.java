package com.ayjs.mxzg.gameserver.module.fetter.event;

import lombok.Value;

/**
 * 羁绊铸魂事件
 */
@Value(staticConstructor = "of")
public class GoddessSoulEvent {
    private long rid;
    //新的铸魂等级
    private int soul_level;
}
