package com.ayjs.mxzg.battle.command;

import java.util.List;

import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.command.Command;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

/**
 * 英雄初始化
 * @author meiyc
 *
 */
@Getter
@Setter
@RequiredArgsConstructor
public class HeroInitCommand implements Command {

	/** 英雄初始化 */
	private final List<HeroVo> heroVos;
	/** 英雄do信息 */
	private List<HeroDo> heroDos;
	
	public static HeroInitCommand createOf(List<HeroVo> heroVos){
		return new HeroInitCommand(heroVos);
	}
}
