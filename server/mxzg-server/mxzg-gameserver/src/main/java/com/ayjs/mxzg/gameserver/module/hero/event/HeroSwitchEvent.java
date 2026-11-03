/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import lombok.Value;

import java.util.List;

/**
 * 英雄置换事件
 */
@Value(staticConstructor = "of")
public class HeroSwitchEvent {
	private Hero hero;
	private GameEvent gameEvent;
	private int oriType;
	private List<ImmutableThing> costList;
	private List<Long> deteleHeros;
}
