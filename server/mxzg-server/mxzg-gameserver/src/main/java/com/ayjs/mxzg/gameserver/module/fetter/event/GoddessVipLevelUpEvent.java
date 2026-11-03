package com.ayjs.mxzg.gameserver.module.fetter.event;


import lombok.Value;

/**
 * 羁绊VIP升级事件
 * @author hyx
 *
 */
@Value(staticConstructor = "of")
public class GoddessVipLevelUpEvent {
    private long rid;

    /**
     * 新的羁绊等级
     */
    private int newGoddessVip;
}
