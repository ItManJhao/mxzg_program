package com.ayjs.mxzg.battle.buff.condition;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 目标是否中了指定的buff中的一个
 *
 * @author meiyc
 */
@Component
public class TargetBuffCheckerBuffHandler extends AbstractConditionBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_TARGET_BUFF_CHECKER;
    }

    @Override
    protected boolean checkCondition(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
        return buff.getValues().stream().filter(value -> value != 0).map(type-> ConvertUtils.toEnum(type, BuffType.class)).anyMatch(defender::haveBuff);
    }

}
