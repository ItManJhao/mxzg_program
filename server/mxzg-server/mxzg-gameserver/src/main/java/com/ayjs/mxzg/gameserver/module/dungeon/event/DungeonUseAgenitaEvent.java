package com.ayjs.mxzg.gameserver.module.dungeon.event;

import lombok.Value;

/**
 * 庇护所药剂使用
 * @author hyx
 */
@Value(staticConstructor = "of")
public class DungeonUseAgenitaEvent {

    private long rid;

    private int type;//药剂类型

}
