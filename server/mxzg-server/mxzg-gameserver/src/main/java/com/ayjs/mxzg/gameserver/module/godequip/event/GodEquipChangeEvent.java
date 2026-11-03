/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.godequip.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class GodEquipChangeEvent {
	private Hero hero;
	private GameEvent gameEvent;
}
