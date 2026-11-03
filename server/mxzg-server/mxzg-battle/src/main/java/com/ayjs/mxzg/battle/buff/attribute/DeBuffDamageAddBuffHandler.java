package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * Debuff 伤害加成，根据debuff的个数加成伤害
 * @author meiyc
 *
 */
@Component
public class DeBuffDamageAddBuffHandler extends AbstractBaseAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_DEBUFF_DAMAGE_ADD;
	}

	@Override
	protected void handleEffect(BuffDo buffDo, HeroDo attacker, HeroDo target, Builder builder) {

	}
}
