package com.ayjs.mxzg.gameserver.module.hero.command;

import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.command.Command;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

/**
 * 查询英雄信息
 * @author meiyc
 *
 */
@Getter
@Setter
@RequiredArgsConstructor
public class QueryHeroCommand implements Command {

	/** 英雄 */
	private final Hero hero;
	
	/** 英雄do信息 */
	private HeroDo heroDo;

	/** 查询的模块 */
	private final ModuleType filterType;
	
	public static QueryHeroCommand createOf(Hero hero){
		return new QueryHeroCommand(hero, ModuleType.NONE);
	}

	public static QueryHeroCommand createOf(Hero hero, ModuleType filterType){
		return new QueryHeroCommand(hero, filterType);
	}

	/**
	 * 是否过滤掉目标类型
	 * @param targetType
	 * @return
	 */
	public boolean isFilter(ModuleType targetType){
		return this.filterType == targetType;
	}

}
