package com.ayjs.mxzg.gameserver.module.role.event;


import lombok.Value;

/**
 * 最大战力变化事件
 */
@Value(staticConstructor = "of")
public class MaxFightingEvent {

    private long rid;

    private int maxFighting;

    private int oldMaxFighting;

}
