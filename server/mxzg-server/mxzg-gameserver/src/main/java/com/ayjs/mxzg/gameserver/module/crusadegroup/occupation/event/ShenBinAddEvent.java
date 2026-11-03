package com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event;

import lombok.Value;

import java.util.Map;

/**
 * 神兵精华增加事件
 */
@Value(staticConstructor = "of")
public class ShenBinAddEvent {
    private long rid;//玩家id

    private Map<Integer, Long> addItem;
}
