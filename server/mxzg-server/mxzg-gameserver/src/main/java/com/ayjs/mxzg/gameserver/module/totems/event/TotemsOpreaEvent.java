package com.ayjs.mxzg.gameserver.module.totems.event;

import lombok.Value;

@Value(staticConstructor = "of")
public class TotemsOpreaEvent {
    private long rid;
    private long heroId;
}
