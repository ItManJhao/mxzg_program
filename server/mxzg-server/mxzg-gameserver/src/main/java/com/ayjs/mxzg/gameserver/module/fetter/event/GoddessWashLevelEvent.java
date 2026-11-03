package com.ayjs.mxzg.gameserver.module.fetter.event;

import lombok.Value;

/**
 * 羁绊女神洗炼
 * @author hyx
 */
@Value(staticConstructor = "of")
public class GoddessWashLevelEvent {

    private long rid;
    //新的洗炼等级
    private int soul_level;

}
