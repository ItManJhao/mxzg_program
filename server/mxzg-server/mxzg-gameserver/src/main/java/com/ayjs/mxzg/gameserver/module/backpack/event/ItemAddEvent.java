package com.ayjs.mxzg.gameserver.module.backpack.event;

import java.util.List;
import java.util.Map;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class ItemAddEvent {
    private long rid;
    private List<ImmutableThing> addValue;
    private GameEvent gameEvent;
    private Map<Integer, Long> currMap;
}
