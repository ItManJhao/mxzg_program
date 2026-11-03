/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.hero.command;

import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Command;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import java.util.List;

/**
 * @author YY
 *
 */
@Getter
@Setter
@RequiredArgsConstructor
public class QueryHerosCommand implements Command {

	/** 英雄 */
	private final List<Hero> heros;
	
	/** 英雄do信息 */
	private List<HeroDo> heroDos;

	/** 只包含属性，不包含阵容跟精灵加成 */
	private final boolean onlyHeroAttribute;
	
	public static QueryHerosCommand createOf(List<Hero> heros){
		return new QueryHerosCommand(heros, false);
	}

	public static QueryHerosCommand createOfOnlyHero(List<Hero> heros){
		return new QueryHerosCommand(heros, true);
	}
}
