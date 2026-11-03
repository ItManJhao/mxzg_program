/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.event;

import java.util.List;
import java.util.Map;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class AllHeroFightChangeEvent {
	private long rid;
	private List<Hero> heros;
	private GameEvent gameEvent;
	private Map<Long, Integer> oriFightings;
	private Map<Long, Integer> currFightings;
}
