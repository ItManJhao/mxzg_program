package com.ayjs.mxzg.battle.buff.condition;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 目标中了指定的debuff的时候才执行后续的artId，否则中断自己的后续执行
 *
 * @author meiyc
 */
@Component
public class TargetDebuffBuffHandler extends AbstractConditionBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_TARGET_DEBUFF_SELECT;
    }

    @Override
    protected boolean checkCondition(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
        int buffTypeValue = buff.getValue()[0];
        BuffType buffType = ConvertUtils.toEnum(buffTypeValue, BuffType.class);
        List<BuffDo> buffDos = defender.getBuffsBy(buffType);
        if (buffDos.isEmpty()) {
            attacker.interrupt(attacker.getUnitId());
        }
        return true;
    }
}
