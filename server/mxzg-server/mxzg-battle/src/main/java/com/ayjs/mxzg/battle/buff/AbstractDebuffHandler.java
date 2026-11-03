package com.ayjs.mxzg.battle.buff;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * 抽象的debuff处理器，过滤掉被抵抗的buff
 * @author meiyc
 *
 */
@Component
public abstract class AbstractDebuffHandler extends AbstractResistanceHandler {


	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		if(defender.haveBuff(BuffType.BT_IMMUNITY_DEBUFF)) {
			return;
		}

		super.handle(buff, attacker, defender, context, builder);
	}

}
