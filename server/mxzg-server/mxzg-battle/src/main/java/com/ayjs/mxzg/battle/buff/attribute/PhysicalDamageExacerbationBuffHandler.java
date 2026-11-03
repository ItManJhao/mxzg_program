package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 物理伤害加深
 * @author meiyc
 *
 */
@Component
public class PhysicalDamageExacerbationBuffHandler extends AbstractAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_PHYSICAL_DAMAGE_EXACERBATION;
	}

}
