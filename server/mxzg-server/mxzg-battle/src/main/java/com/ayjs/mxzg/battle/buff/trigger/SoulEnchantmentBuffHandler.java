/**
 * 
 */
package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.service.BattleService;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo;
import com.ayjs.mxzg.protocol.BattleGMsg.EffectInfo;
import com.google.common.collect.Sets;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author YY
 * 灵魂结界，分担伤害
 */
@Component
public class SoulEnchantmentBuffHandler extends AbstractArtTriggerBuffHandler {

	@Autowired
	private BattleService battleService;

	@Override
	public BuffType getType() {
		return BuffType.BT_SOUL_ENCHANTMENT;
	}

	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		//攻击方打出的伤害
		DamageResult result = target.getResult();
		
		BattlerDo battlerDo = context.getSelf(beTrigger.getFaction());
		List<HeroDo> shareFriends = battlerDo.getHeroByBuff(getType());

		//分摊的伤害
		long shareDamage = result.getDamage() / shareFriends.size();
		shareFriends.remove(beTrigger);
		result.setDamage(shareDamage);

		DamageResult shareResult = DamageResult.builder().damage(shareDamage).hitType(result.getHitType())
				.buffId(result.getBuffId()).fixedAttack(true).block(result.isBlock()).build();

		for(HeroDo shareFriend : shareFriends) {
			addDamageBuff(buff.getBuff(), shareResult, target, shareFriend, context);
		}
	}

	@Override
	public void removeBuff(BuffDo buff, HeroDo target, BattleContext context) {
		if(buff.isSelf()){
			int artId = buff.getBuff().getValue()[0];
			HeroDo source = context.getHero(buff.getSourceId());
			LinkedHashSet<HeroDo> targetSet = Sets.newLinkedHashSet();
			targetSet.add(target);
			List<EffectInfo> effectInfos = battleService.executeBuffArt(artId, targetSet, source, context);
			List<BuffInfo> buffInfos = effectInfos.stream().flatMap(effectInfo -> effectInfo.getBuffInfoList().stream()).collect(Collectors.toList());
			buffInfos.forEach(context::addUpdateBuff);
		}
	}
}
