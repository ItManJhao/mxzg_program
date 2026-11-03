package com.ayjs.mxzg.battle.condition;

import com.ayjs.mxzg.battle.model.BattleCondition;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.ConditionType;

/**
 * 战场失败条件检测接口
 */
public interface ConditionChecker {

    /**
     * 条件类型
     * @return
     */
    ConditionType type();

    /**
     * 检测战场失败条件，
     * @param context
     * @return true代表符合条件，false代表不符合条件，不符合条件则战场结束攻方失败
     */
    boolean checker(BattleContext context, BattleCondition condition);
}
