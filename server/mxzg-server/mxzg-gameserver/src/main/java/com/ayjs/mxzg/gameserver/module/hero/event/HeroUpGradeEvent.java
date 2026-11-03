/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.event;

import java.util.List;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;

import lombok.Value;

/**
 * @author YY
 * 英雄升阶事件
 */
@Value(staticConstructor = "of")
public class HeroUpGradeEvent {
	private Hero hero;
	private GameEvent gameEvent;
	private int oriStage;
	private List<ImmutableThing> costList;
}
