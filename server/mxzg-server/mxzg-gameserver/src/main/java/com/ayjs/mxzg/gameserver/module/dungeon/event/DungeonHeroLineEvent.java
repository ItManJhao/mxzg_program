package com.ayjs.mxzg.gameserver.module.dungeon.event;

import lombok.Value;

/**
 * 庇护所战斗队伍保存事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class DungeonHeroLineEvent {

    private long rid;

}
