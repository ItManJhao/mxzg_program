package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 魔法伤害加深
 * @author meiyc
 *
 */
@Component
public class MagicDamageExacerbationBuffHandler extends AbstractAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_MAGIC_DAMAGE_EXACERBATION;
	}
	

}
