package com.ayjs.mxzg.battle.buff.function;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;

/**
 * 客户端buff处理器
 * @author meiyc
 *
 */
@Component
public class ClientBuffHandler extends AbstractBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_AMIN;
	}

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		addBuff(buff, attacker, defender, builder, context);
	}

}
