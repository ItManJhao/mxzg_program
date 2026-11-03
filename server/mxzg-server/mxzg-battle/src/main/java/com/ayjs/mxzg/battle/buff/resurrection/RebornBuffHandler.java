package com.ayjs.mxzg.battle.buff.resurrection;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * 重生
 * @author meiyc
 *
 */
@Component
public class RebornBuffHandler extends AbstractResurrectionBuffHandler {


	@Override
	public BuffType getType() {
		return BuffType.BT_REBORN;
	}

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		int rebornHpRate = buff.getValue()[0];
		resurrection(buff.getIdx(), rebornHpRate, attacker, defender, context, builder);
	}
	
}
