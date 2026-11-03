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
 * @author YY
 * 英雄升级事件
 */
@Value(staticConstructor = "of")
public class HeroUpLevelEvent {
	private Hero hero;
	private GameEvent gameEvent;
	private int oriLevel;
	private List<ImmutableThing> costList;
	private int upLevel;
}
