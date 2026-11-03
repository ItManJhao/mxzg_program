package com.ayjs.mxzg.gameserver.module.role.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import lombok.Value;

@Value(staticConstructor = "of")
public class RolePeerageChangeEvent {

    private long rid;

    private GameEvent gameEvent;

}
