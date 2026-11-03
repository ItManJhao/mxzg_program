/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class HeroEquipChangeEvent {
	private Hero hero;
	private GameEvent gameEvent;
}
