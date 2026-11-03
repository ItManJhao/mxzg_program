package com.ayjs.mxzg.battle.targetselector;

import java.util.List;
import java.util.Set;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.tuple.Tuple2;
import com.ayjs.mxzg.config.struct.SelectorType;

/**
 * 目标选择器
 * @author meiyc
 *
 */
public interface TargetSelector{
	/**
	 * 获取目标类型
	 * @return
	 */
	SelectorType getType();

	/**
	 * 选择目标
	 * @param context
	 * @param attacker
	 * @param targets
	 * @param targetNum
	 * @param targetValue 选择条件参数
	 */
	void selectTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets, int targetNum, List<Integer> targetValue);

	/**
	 * 默认提供选择所有敌方目标
	 * @param context
	 * @param attacker
	 * @param targets
	 */
	default void selectAllTarget(BattleContext context, HeroDo attacker, Set<HeroDo> targets){
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
	default Tuple2<Integer, Integer> getRowColumn(int position) {
		int row = (position - 1) / BattleConstant.ROW_NUMBER;
		return new Tuple2<>(row + 1, position - row * BattleConstant.ROW_NUMBER);
	}
}
