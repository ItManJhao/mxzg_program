package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;

/**
 * 抽象的属性类型buff处理器
 * @author meiyc
 *
 */
public abstract class AbstractBaseAttributeBuffHandler extends AbstractBuffHandler {
	

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		BuffDo buffDo = addBuff(buff, attacker, defender, builder, context);
		if(buffDo != null){
			handleEffect(buffDo, attacker, defender, builder);
		}
	}
	
	/**
	 * 处理buff属性效果
	 * @param buffDo
	 * @param attacker
	 * @param target
	 * @param builder
	 */
	protected abstract void handleEffect(BuffDo buffDo, HeroDo attacker, HeroDo target, Builder builder);


}
