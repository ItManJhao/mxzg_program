package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 使用普攻或技能对目标造成伤害时触发
 * @author meiyc
 *
 */
@Component
public class DealingDamageBuffHandler extends AbstractArtTriggerBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_DEALING_DAMAGE;
	}

}
