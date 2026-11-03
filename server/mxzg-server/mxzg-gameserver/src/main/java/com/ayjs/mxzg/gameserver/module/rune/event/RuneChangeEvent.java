/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.rune.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;

import lombok.Value;

/**
 * @author YY
 * 精灵穿戴事件
 */
@Value(staticConstructor = "of")
public class RuneChangeEvent {
	private Hero hero;
	private GameEvent gameEvent;
}
