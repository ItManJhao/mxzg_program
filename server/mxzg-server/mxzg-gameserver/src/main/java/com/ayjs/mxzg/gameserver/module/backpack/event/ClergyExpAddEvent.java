package com.ayjs.mxzg.gameserver.module.backpack.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import lombok.Value;

/**
 * 神职经验增加
 * @author hyx
 */
@Value(staticConstructor = "of")
public class ClergyExpAddEvent {

    private long rid;
    private long addCount;
    private GameEvent gameEvent;
    private long curr;

}
