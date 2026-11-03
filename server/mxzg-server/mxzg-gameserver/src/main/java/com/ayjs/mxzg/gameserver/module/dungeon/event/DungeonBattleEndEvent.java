package com.ayjs.mxzg.gameserver.module.dungeon.event;

import lombok.Value;

/**
 * 庇护所战斗结束
 * @author hyx
 */
@Value(staticConstructor = "of")
public class DungeonBattleEndEvent {

    private long rid;

    private int heroType;

    private int monsterLevel ;//怪物标识

    private boolean win;

}
