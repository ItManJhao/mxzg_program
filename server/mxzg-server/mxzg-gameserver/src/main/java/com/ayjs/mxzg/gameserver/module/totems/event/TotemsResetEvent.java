package com.ayjs.mxzg.gameserver.module.totems.event;

import lombok.Value;

@Value(staticConstructor = "of")
public class TotemsResetEvent {

    private long rid;//玩家id

    private long tId;//图腾id

    private long heroId;//英雄id <=0表示未装备
}
