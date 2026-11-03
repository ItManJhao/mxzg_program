package com.ayjs.mxzg.battle.buff;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.HitType;
import com.ayjs.mxzg.battle.service.BattleService;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

/**
 * buff抽象类，提供buff基础功能
 * @author meiyc
 *
 */
public abstract class AbstractBuffHandler implements BuffHandler {

	@Autowired
	protected BuffHelper buffHelper;
	@Autowired
	protected BattleService battleService;
	@Autowired
	protected BattleTrigger battleTrigger;
	
	/**
	 * 添加buff信息
	 * @param buff
	 * @param attacker
	 * @param defender
	 * @param builder
	 * @param context
	 * @return
	 */
	protected BuffDo addBuff(CBuff buff, HeroDo attacker, HeroDo defender, Builder builder, BattleContext context){
		if(defender.isDead() && buff.getType().isLogic() && !buff.getType().isDeathExecute())return null;

		if(buff.getType().isShield()){
			List<BuffDo> buffDos = defender.getBuffsBy(BuffType.BT_SHIELD);
			if(!buffDos.isEmpty()){
				return buffDos.get(0);
			}
		}

		int expiredRound = context.getRound().get() + buff.getRound();
		BuffDo buffDo = BuffDo.createOf(context.nextUnitId(), defender.getUnitId(), attacker.getUnitId(), expiredRound, buff, attacker.currentSkillIsHalo());
		if(getType().isLogic()){
			List<BuffDo> removeBuffs = defender.addBuffAndRtnRemoveBuffs(buffDo);
			for(BuffDo removeBuff : removeBuffs){
				buffHelper.removeBuff(removeBuff, defender, context);
			}
		}

		callback(buffDo, attacker, defender, context);
		return buffDo.buildBaseTo(builder);
	}

	/**
	 * 回调buff给业务buff
	 * @param buffDo
	 * @param attacker
	 * @param defender
	 * @param context
	 */
	protected void callback(BuffDo buffDo, HeroDo attacker, HeroDo defender, BattleContext context){
		// 默认什么都不做
	}
	
	/**
	 * 构造buff
	 * @param buffId
	 * @param target
	 * @param builder
	 * @param context
	 * @return
	 */
	protected void buildBuff(int buffId, HeroDo target, Builder builder, BattleContext context){
		builder.setBuffId(buffId).setTargetUnitId(target.getUnitId()).setUnitId(context.nextUnitId()).setHit(HitType.HIT.ordinal());
	}

}
