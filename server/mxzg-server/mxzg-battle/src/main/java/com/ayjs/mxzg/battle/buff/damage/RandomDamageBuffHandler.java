package com.ayjs.mxzg.battle.buff.damage;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.service.BattleService;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.battle.util.FightUtil;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * 随机攻击1-5个目标
 * @author meiyc
 *
 */
@Component
public class RandomDamageBuffHandler extends AbstractDamageBuffHandler {

	@Autowired
	private BattleService battleService;

	@Override
	public BuffType getType() {
		return BuffType.BT_RANDOM_DAMAGE;
	}

	@Override
	protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
		List<List<Integer>> randomInfos = buildRandomList(buff);
		List<Integer> targetInfo = getTarget(randomInfos);
		int targetNum = targetInfo.get(1);
		BattlerDo battlerDo = context.getEnemy(attacker.getFaction());
		targetNum = Math.min(targetNum, battlerDo.getHeros().size()) - 1 ;
		List<HeroDo> targets = RandomUtil.randomList(battlerDo.getHeros(), targetNum);
		targets.add(defender);

		for(int i = 0; i < targets.size(); i++){
			List<Integer> damages = randomInfos.get(i);
			HeroDo target = targets.get(i);
			DamageResult result = FightUtil.calDamage(damages.get(2), attacker, target, true);
			addSkillDamage(result, buff, attacker, target, context);

			double artRate = AttributeUtil.calPercent(damages.get(3));
			if(RandomUtils.isHit(artRate)){
				battleService.executeBuffArt(damages.get(4), target, attacker, context);
			}
		}

		return DamageResult.builder().build();
	}

	/**
	 * 构建战斗数据
	 * @param buff
	 * @return
	 */
	private List<List<Integer>> buildRandomList(CBuff buff){
		List<List<Integer>> list = new ArrayList<>();
		for(int i = 0; i < buff.getValues().size() / 5; i++){
			int startIndex = i * 5;
			list.add(buff.getValues().subList(startIndex, (startIndex + 5)));
		}
		return list;
	}

	/**
	 * 选择随机的单位
	 * @param randomInfos
	 * @return
	 */
	private List<Integer> getTarget(List<List<Integer>> randomInfos){
		int randomValue = RandomUtils.nextInt((int)BattleConstant.LONG_PERCENTAGE_RATIO);
		for(int num = 0; num < randomInfos.size(); num++){
			List<Integer> damages = randomInfos.get(num);
			if(randomValue < damages.get(0)){
				return damages;
			}
		}
		return randomInfos.get(0);
	}

}
