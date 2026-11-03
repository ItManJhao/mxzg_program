package com.ayjs.mxzg.battle.buff.attribute;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.EnumUtils;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 根据英雄元素个数来加成属性
 * @author meiyc
 *
 */
@Component
public class ElementAddBuffHandler extends AbstractAttributeBuffHandler {

	@Override
	public BuffType getType() {
		return BuffType.BT_ELEMENT_ADD;
	}

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		BuffDo buffDo = addBuff(buff, attacker, defender, builder, context);
		if(buffDo != null){
			long baseAddValue = buffDo.getBuff().getValue()[0];
			int attributeType = buffDo.getBuff().getValue()[1];
			int elementType = buffDo.getBuff().getValue()[2];
			int addValue = buffDo.getBuff().getValue()[3];
			BattlerDo self = context.getSelf(attacker.getFaction());
			List<HeroDo> elementHeroes = self.getAllHeros().stream().filter(hero-> hero.isElement(elementType)).collect(Collectors.toList());
			addValue *= elementHeroes.size();
			long totalValue = baseAddValue + addValue;
			AttributeType type = EnumUtils.getEnumByValue(AttributeType.class, attributeType);
			defender.getAttributeInfo().updateAttribute(type, totalValue);
			buffDo.setValue(totalValue);
		}
	}


	@Override
	public void removeBuff(BuffDo buff, HeroDo target, BattleContext context) {
		int attributeType = buff.getBuff().getValue()[1];
		AttributeType type = EnumUtils.getEnumByValue(AttributeType.class, attributeType);
		target.getAttributeInfo().updateAttribute(type, -buff.getValue());
	}
}
