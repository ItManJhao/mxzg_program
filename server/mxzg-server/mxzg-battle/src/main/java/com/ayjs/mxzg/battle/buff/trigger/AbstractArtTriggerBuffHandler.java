package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.buff.AbstractBaseDamageBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.cache.BuffArtSysCache;
import com.ayjs.mxzg.config.excel.cache.BuffSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.excel.entity.CBuffArt;
import com.ayjs.mxzg.config.struct.SourceType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.CollectionUtils;

/**
 * 抽象的art触发器
 * @author meiyc
 *
 */
public abstract class AbstractArtTriggerBuffHandler extends AbstractBaseDamageBuffHandler {

	@Autowired
	protected BuffSysCache buffSysCache;
	@Autowired
	protected BuffArtSysCache buffArtSysCache;

	
	@Override
	public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
		addBuff(buff, attacker, defender, builder, context);
	}
	
	@Override
	public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
		if(context.isOver() || !checkCondition(buff, beTrigger, target, context)){
			return;
		}
		for (int artId : buff.getBuff().getArt_list()) {
			CBuffArt buffArt = buffArtSysCache.getOrThrow(artId);
			HeroDo source = context.getHero(buff.getSourceId());
			HeroDo attacker = buffArt.getSource_type() == SourceType.APPLICATOR ? source : beTrigger;
			target = getTarget(buff, buffArt, beTrigger, target);
			battleService.executeBuffArt(artId, target, attacker, context);
		}
	}

	/**
	 * 检测触发条件是否满足
	 * @param buff
	 * @param beTrigger
	 * @param target
	 * @param context
	 * @return
	 */
	protected  boolean checkCondition(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context){
		return true;
	}
	
	/**
	 * 检查触发次数，如果达到指定的触发次数则移除buff
	 * @param buff
	 * @param beTrigger
	 * @param context
	 * @return 返回是否触发成功
	 */
	protected boolean checkTriggerTimes(BuffDo buff, HeroDo beTrigger, BattleContext context){
		int triggerTimes = getTriggerTimes(buff.getBuff());
		buff.addValue(1);
		if(triggerTimes != 0 && buff.getValue() >= triggerTimes ){
			buffHelper.removeBuff(buff, beTrigger, context);
			return false;
		}
		
		return true;
	}
	
	/**
	 * 获取触发次数，默认0触发次数不限
	 * @return
	 */
	protected int getTriggerTimes(CBuff buff){
		return 0;
	}; 

	/**
	 * 获取buff目标
	 * @param buff
	 * @param buffArt
	 * @param beTrigger
	 * @param target
	 * @return
	 */
	private HeroDo getTarget(BuffDo buff, CBuffArt buffArt, HeroDo beTrigger, HeroDo target){
		if(CollectionUtils.isEmpty(buffArt.getTarget())){
			return buff.isSelf() ? target : beTrigger;
		}
		return beTrigger;
	}
	
}
