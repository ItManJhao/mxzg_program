package com.ayjs.mxzg.gameserver.module.backpack.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import lombok.Value;

/**
 * 超级钻石减少
 *
 * @author tangyangbo
 */
@Value(staticConstructor = "of")
public class SuperGemCostEvent {
    private long rid;
    private long costCount;
    private GameEvent gameEvent;
    private long curr;
}
