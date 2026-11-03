package com.ayjs.mxzg.gameserver.module.prophetSummon.event;

import lombok.Value;

/**
 * 英雄置换确认
 *
 **/
@Value(staticConstructor = "of")
public class HeroChangeAffirmEvent {
    private long rid;
}
