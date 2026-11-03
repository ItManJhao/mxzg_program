package com.ayjs.mxzg.battle.command;

import java.util.Collection;
import java.util.List;

import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.common.command.Command;
import com.ayjs.mxzg.config.struct.HeroInfo;

import lombok.Getter;
import lombok.Setter;

/**
 * 查询英雄基础属性
 * @author meiyc
 *
 */
@Getter
@Setter
public class HeroBaseCommand implements Command {
	
	/** 单位类型 */
	private UnitType unitType;
	
	/** 英雄信息列表 */
	private Collection<HeroInfo> heros;
	
	/** 英雄列表 */
	private List<HeroDo> heroDos;
	
	
	public static HeroBaseCommand createOf(UnitType unitType, Collection<HeroInfo> heros){
		HeroBaseCommand command = new HeroBaseCommand();
		command.setHeros(heros);
		command.setUnitType(unitType);
		return command;
	}
}
