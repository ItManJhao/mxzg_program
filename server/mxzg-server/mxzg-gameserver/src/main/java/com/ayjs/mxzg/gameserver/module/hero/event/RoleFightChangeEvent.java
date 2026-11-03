/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.event;

import com.ayjs.mxzg.config.struct.GameEvent;

import lombok.Value;

/**
 * @author YY
 * 玩家战力变化事件
 */
@Value(staticConstructor = "of")
public class RoleFightChangeEvent {
	private long rid;
	private GameEvent gameEvent;
	private int oriFighting;
	private int currFighting;
}
