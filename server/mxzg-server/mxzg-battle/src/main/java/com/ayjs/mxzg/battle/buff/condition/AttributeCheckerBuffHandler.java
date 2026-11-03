/**
 * 
 */
package com.ayjs.mxzg.battle.buff.condition;

import com.ayjs.mxzg.battle.model.BattleContext;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;

/**
 * @author YY
 *
 */
@Component
public class AttributeCheckerBuffHandler extends AbstractConditionBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_ATTRIBUTE_CHECKER;
	}

	@Override
	protected boolean checkCondition(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		AttributeType attributeType = AttributeType.valueOf(buff.getValue()[0]);
		long atkAttr = attacker.getAttribute(attributeType);
		long defAttr = defender.getAttribute(attributeType);
		if(buff.getValue()[1] == 0) {
			return defAttr < atkAttr;
		} else {
			return defAttr > atkAttr;
		}
	}

}
