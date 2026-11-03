package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * 增加能量
 * @author meiyc
 *
 */
@Component
public class AngerAddBuffHandler extends AbstractBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_ANGER_ADD;
	}
	
	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {

	}
	
}
