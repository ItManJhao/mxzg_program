package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * 随机buff处理器
 * @author meiyc
 *
 */
@Component
public class RandomBuffHandler extends AbstractBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_RANDOM;
	}

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		//什么都不做
	}

}
