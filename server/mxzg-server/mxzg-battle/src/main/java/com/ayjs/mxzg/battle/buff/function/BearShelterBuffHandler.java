package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.trigger.AbstractArtTriggerBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.ContextType;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * //庇护，伤害转移
 * @author meiyc
 *
 */
@Component
public class BearShelterBuffHandler extends AbstractArtTriggerBuffHandler {

	private Comparator<HeroDo> hpPositiveComp = (o1, o2) -> Double.compare(o1.getHpRate(), o2.getHpRate());

	@Override
	public BuffType getType() {
		return BuffType.BT_BEAR_SHELTER;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		HeroDo source = context.getHero(buff.getSourceId());
		if(source.isDead()){return;	}


		List<BuffDo> bearBuffs = source.getBuffsBy(BuffType.BT_LITTLE_BEAR);
		if(bearBuffs.isEmpty()){
			return;
		}

		DamageResult result = target.getResult();

		BattlerDo self = context.getSelf(source.getFaction());
		long buffId = source.getContext(ContextType.BEAR_ORDER_BUFF_ID);
		if(result.getBuffId() != buffId){
			source.setContext(ContextType.BEAR_ORDER_BUFF_ID, result.getBuffId());
			List<HeroDo> selectTargets = self.getHeros().stream().sorted(hpPositiveComp).collect(Collectors.toList());
			HeroDo leastHero = selectTargets.get(0);
			source.setContext(ContextType.BEAR_SHELTER_HERO, leastHero.getUnitId());
		}

		long unitId = source.getContext(ContextType.BEAR_SHELTER_HERO);
		if(beTrigger.getUnitId() != unitId){
			return;
		}

		long convertRatio = buff.getBuff().getValue()[0];
		long damage = AttributeUtil.addPercent(Math.abs(result.getDamage()), convertRatio);
		result.updateDamage(damage);

		BuffDo bearBuff = bearBuffs.get(0);
		bearBuff.addValue(-damage);
		if(bearBuff.getValue() < 0 ){
			damage = Math.abs(bearBuff.getValue());
			buffHelper.removeBuff(bearBuff, source, context);
			source.setContext(ContextType.BEAR_DEATH_ROUND, context.getRound().get());
		} else {
			damage = 0;
		}
		result.setBear(true);

		if(damage > 0){
			DamageResult convertDamage = DamageResult.builder().damage(-damage).buffId(result.getBuffId()).fixedAttack(true).build();
			addDamageBuff(buff.getBuff(), convertDamage, target, source, context);
		}
	}


}
