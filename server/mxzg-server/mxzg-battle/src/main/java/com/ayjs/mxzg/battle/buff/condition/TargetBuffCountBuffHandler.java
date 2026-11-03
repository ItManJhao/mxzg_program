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
 * 目标是否拥有指定buff的指定层数
 *
 * @author meiyc
 */
@Component
public class TargetBuffCountBuffHandler extends AbstractConditionBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_TARGET_BUFF_COUNT;
    }

    @Override
    protected boolean checkCondition(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
        int buffTypeValue = buff.getValue()[0];
        int count = buff.getValue()[1];
        BuffType buffType = ConvertUtils.toEnum(buffTypeValue, BuffType.class);
        List<BuffDo> buffDos = defender.getBuffsBy(buffType);
        return buffDos.size() >= count;
    }
}
