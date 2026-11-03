package com.ayjs.mxzg.gameserver.module.astrolabe.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2020/4/28
 **/
@Value(staticConstructor = "of")
public class AstrolabeChangeEvent {
    private long rid;

    private GameEvent gameEvent;
}
