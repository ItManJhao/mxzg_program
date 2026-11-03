package com.ayjs.mxzg.gameserver.module.clanworldboss.event;

import lombok.Value;

/**
 * 世界BOSS挑战事件
 *
 * @author hyx
 */
@Value(staticConstructor = "of")
public class ClanWorldBossBattleEvent {

    private long rid;

}
