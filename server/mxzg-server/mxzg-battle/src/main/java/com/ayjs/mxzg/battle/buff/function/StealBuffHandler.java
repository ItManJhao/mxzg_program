package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.buff.BuffHelper;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
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
 * 偷取敌方增益buff给自己
 */
@Component
public class StealBuffHandler extends AbstractBuffHandler {

	@Autowired
	private BuffHelper buffHelper;
	
	@Override
	public BuffType getType() {
		return BuffType.BT_STEAL_BUFF;
	}

	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		int buffNum = buff.getValues().get(0);
        BattlerDo enemy = context.getEnemy(attacker.getFaction());
        int count = 0;
        for(HeroDo target : enemy.getHeros()){
			List<BuffDo> buffDos = target.getBuffsBy(EffectType.GAIN);
			if(buffDos.isEmpty()){
				continue;
			}

			List<BuffDo> buffs = RandomUtil.randomList(buffDos, 1);
			convertBuff(buffs.get(0), target, attacker, context);
			if(++count == buffNum){
				break;
			}
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
		BuffInfo.Builder builder = BuffInfo.newBuilder();
		BuffDo buffDo = addBuff(buff.getBuff(), source, toHero, builder, context);
		if(buffDo != null){
			buffDo.setExpiredRound(buff.getExpiredRound());
			buffHelper.removeBuff(buff, fromHero, context);
			context.addUpdateBuff(builder.build());
		}
	}
}
