package com.ayjs.mxzg.gameserver.module.dreamland.event;

import lombok.Value;

/**
 * 永恒梦境战斗事件(无论输赢)
 * @author hyx
 */
@Value(staticConstructor = "of")
public class DreamlandBattleEvent {

    private long rid;

}

