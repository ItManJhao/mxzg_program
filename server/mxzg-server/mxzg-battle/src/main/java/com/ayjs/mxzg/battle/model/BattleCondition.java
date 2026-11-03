package com.ayjs.mxzg.battle.model;

import com.google.common.collect.Lists;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * 战斗结束条件
 */
@Getter
@Setter
@AllArgsConstructor
public class BattleCondition {

    /** 结束条件类型 */
    private ConditionType conditionType;

    /** 参数列表 */
    private List<Integer> parameter;

    public static BattleCondition valueOf(ConditionType conditionType, List<Integer> parameter){
        return new BattleCondition(conditionType, parameter);
    }

    public static BattleCondition valueOf(ConditionType conditionType, int parameter){
        return new BattleCondition(conditionType, Lists.newArrayList(parameter));
    }

    /**
     * 获取唯一的条件参数
     * @return
     */
    public int getUnique(){
        return parameter.get(0);
    }

}
