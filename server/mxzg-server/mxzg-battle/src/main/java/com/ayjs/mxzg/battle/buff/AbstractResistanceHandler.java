package com.ayjs.mxzg.battle.buff;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 抽象的负面buff处理器，负责抵抗属性处理
 * @author meiyc
 *
 */
@Component
public abstract class AbstractResistanceHandler extends AbstractBaseDamageBuffHandler {

	@Autowired
	protected BattleTrigger battleTrigger;

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		AttributeType resistanceAttribute = buff.getType().buffResistanceAttribute();
		double resistanceRate = resistanceAttribute == null ? 0 : defender.getRate(resistanceAttribute);
		double attchPercent = buff.getAttchPercent();
		attchPercent = attchPercent * (1 - resistanceRate);
		if(!RandomUtils.isHit(attchPercent)){
			if(resistanceAttribute != null){
				builder.addResistances(resistanceAttribute.getValue());
			}
			return;
		}
		
		addBuff(buff, attacker, defender, builder, context);

	}


}
