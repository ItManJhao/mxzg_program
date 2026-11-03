package com.ayjs.mxzg.battle.buff;

import com.ayjs.mxzg.battle.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class BuffHelper {

	@Autowired
	private BuffHandlerHolder handlerHolder;


	/**
	 * 移除buff列表
	 * @param buffDos
	 * @param target
	 * @param context
	 */
	public void removeBuffs(List<BuffDo> buffDos, HeroDo target, BattleContext context){
		buffDos.stream().forEach(buffDo -> removeBuff(buffDo, target, context));
	}
	
	/**
	 * 移除buff
	 * @param buffDo
	 * @param target
	 * @param context
	 */
	public void removeBuff(BuffDo buffDo, HeroDo target, BattleContext context){
		buffDo.expired();
		target.removeBuff(buffDo);
		BuffHandler buffHandler = handlerHolder.getBuffHandler(buffDo.getType());
		buffHandler.removeBuff(buffDo, target, context);
		context.addUpdateBuff(buffDo.toBuffInfo());
		if(buffDo.getType().isOverlay()){
			for(int i = 1; i < buffDo.getValue(); i++){
				context.addUpdateBuff(buffDo.toBuffInfo());
			}
		}
	}

	/**
	 * 根据死亡移除(暂时实现为有光环技能时，移除所有该英雄提供给队友的增益)
	 * @param defender
	 * @param context
	 */
	public void removeByDead(HeroDo defender, BattleContext context){
		removeBuffs(defender.getDeadRemoveBuffs(), defender, context);
		for (SkillDo skill : defender.getSkillInfo().getAllSkills()) {
			if(skill.isHalo()){
				BattlerDo battlerDo = context.getSelf(defender.getFaction());
				for (HeroDo hero : battlerDo.getHeros()) {
					List<BuffDo> buffDos = hero.getHaloBy(defender.getUnitId());
					removeBuffs(buffDos, hero, context);
				}
				break;
			}
		}
	}


}
