package com.ayjs.mxzg.battle.targetselector;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.tuple.Tuple2;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.SelectorType;

/**
 * 抽象的目标选择器
 * 子类中只需要实现
 * selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum, List<Integer> targetValue)
 * 或
 * selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum)
 * 其中一个即可
 */
public abstract class AbstractTargetSelector {

	@Autowired
	private TargetSelectorHolder selectorHolder;
	
	public abstract SelectorType getType();
	
    public final void selectingTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum, List<Integer> targetValue) {
    	BuffType reselectBuff = null;
    	for(BuffType buffType : BuffType.TARGET_RESELECT_BUFFS) {
    		if(attacker.haveBuff(buffType)) {
    			reselectBuff = buffType;
    			break;
    		}
    	}
    	if(reselectBuff != null && reselectBuff.reSelectTargetType() != null) {
    		AbstractTargetSelector targetSelector = selectorHolder.getOrThrow(reselectBuff.reSelectTargetType());
    		targetSelector.selectTarget(context, attacker, targets, targetNum, targetValue);
    	} else {
    		selectTarget(context, attacker, targets, targetNum, targetValue);
    	}
    }

    /**
     * 带参数的目标选择器
     * @param context
     * @param attacker
     * @param targets
     * @param targetNum
     * @param targetValue
     */
	protected void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum, List<Integer> targetValue) {
		selectTarget(context, attacker, targets, targetNum);
	}
    
    /**
     * 不带参数的目标选择器
     * @param context
     * @param attacker
     * @param targets
     * @param targetNum
     */
    protected void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum) {};
    
    /**
	 * 默认提供选择所有敌方目标
	 * @param context
	 * @param attacker
	 * @param targets
	 */
	public void selectAllTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets){
		targets.clear();
		BattlerDo enemy = context.getEnemy(attacker.getFaction());
		targets.addAll(enemy.getHeros());
	};

	/**
	 * 获取英雄所在位置的行和列
	 *
	 * @param position
	 * @return
	 */
	public Tuple2<Integer, Integer> getRowColumn(int position) {
		int row = (position - 1) / BattleConstant.ROW_NUMBER;
		return new Tuple2<>(row + 1, position - row * BattleConstant.ROW_NUMBER);
	}
    
}
