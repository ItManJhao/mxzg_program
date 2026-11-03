package com.ayjs.mxzg.gameserver.module.totems.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.totems.domain.Totems;
import lombok.Value;

import java.util.List;


@Value(staticConstructor = "of")
public class TotemsAddEvent {

    private long rid;

    private List<Totems> totemsList;

    private GameEvent gameEvent;
}
