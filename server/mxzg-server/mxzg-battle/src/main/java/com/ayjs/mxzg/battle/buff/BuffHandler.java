package com.ayjs.mxzg.battle.buff;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo;

/**
 * buff处理器
 * @author meiyc
 *
 */
public interface BuffHandler {

	/**
	 * buff类型
	 * @return
	 */
	BuffType getType();
	
	/**
	 * 处理buff效果
	 * @param buff
	 * @param attacker
	 * @param defender
	 * @param context
	 * @param builder
	 */
	void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, BuffInfo.Builder builder);
	
	/**
	 * 执行回合buff效果
	 * @param buff
	 * @param target
	 * @param context
	 * @param builder
	 */
	default void executeRound(BuffDo buff, HeroDo target, BattleContext context, BuffInfo.Builder builder){};
	
	/**
	 * 触发buff
	 * @param buff
	 * @param betrigger
	 * @param target
	 * @param context
	 */
	default void trigger(BuffDo buff, HeroDo betrigger, HeroDo target, BattleContext context){};
	
	/**
	 * 删除buff时调用
	 * @param buff
	 * @param target
	 * @param context
	 */
	default void removeBuff(BuffDo buff, HeroDo target, BattleContext context){};
	
}
