package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.buff.BuffHelper;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.EffectType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 驱散友方debuff嫁祸给敌方随机后排
 */
@Component
public class MarryBuffHandler extends AbstractBuffHandler {

	@Autowired
	private BuffHelper buffHelper;

	@Override
	public BuffType getType() {
		return BuffType.BT_MARRY;
	}

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		int buffNum = buff.getValue()[0];
		int unitNum = buff.getValue()[1];
		List<HeroDo> heroes = context.getSelf(attacker.getFaction()).getHeros();
		heroes = RandomUtil.randomList(heroes, unitNum);
		boolean update = false;
		for (HeroDo hero : heroes) {
			List<BuffDo> buffs = hero.getBuffsBy(EffectType.DEBUFF);
			if(buffs.isEmpty()){
				continue;
			}

			List<BuffDo> transferBuffs = RandomUtil.randomList(buffs, buffNum);
			transferBuffs.forEach(transferBuff -> convertBuff(transferBuff, hero, defender, context));
			update = true;
		}
		if(update){
			buildBuff(buff.getIdx(), attacker, builder, context);
		}
 	}

    /**
     * 将指定的buff从fromHero身上转移到toHero身上
	 * @param buff
     * @param fromHero
     * @param toHero
	 * @param context
	 */
 	private void convertBuff(BuffDo buff, HeroDo fromHero, HeroDo toHero, BattleContext context){
 		HeroDo source = context.getHero(buff.getSourceId());
		Builder builder = BuffInfo.newBuilder();
		BuffDo buffDo = addBuff(buff.getBuff(), source, toHero, builder, context);
		if(buffDo != null){
			buffDo.setExpiredRound(buff.getExpiredRound());
			buffHelper.removeBuff(buff, fromHero, context);
			context.addUpdateBuff(builder.build());
		}
	}
}
