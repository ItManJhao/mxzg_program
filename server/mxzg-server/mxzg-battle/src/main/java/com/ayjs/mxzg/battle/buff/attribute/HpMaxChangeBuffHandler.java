package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * 修改英雄最大生命值，该效果不在战斗中生效
 * @author meiyc
 *
 */
@Component
public class HpMaxChangeBuffHandler extends AbstractBaseAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_HP_MAX_CHANGE;
	}
	
	
	@Override
	protected void handleEffect(BuffDo buffDo, HeroDo attacker, HeroDo target, Builder builder) {
		int maxHpRate = buffDo.getBuff().getValue()[0];	
		target.updateMaxHp(maxHpRate);
	}	
	
}
