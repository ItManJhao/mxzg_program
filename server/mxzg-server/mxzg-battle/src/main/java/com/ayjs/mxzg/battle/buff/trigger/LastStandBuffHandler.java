package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 背水一战 ，血量越低增加的属性越多
 */
@Component
public class LastStandBuffHandler extends AbstractArtTriggerBuffHandler {


    @Override
    public BuffType getType() {
        return BuffType.BT_LAST_STAND;
    }


    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        int hpRate = buff.getBuff().getValue()[0];
        double lossHpRate = 1 - beTrigger.getHpRate();
        int count = lossHpRate == 0 ? 0 : (int) (lossHpRate / (hpRate / BattleConstant.PERCENTAGE_RATIO));

        int baseRate = buff.getBuff().getValue()[1];
        int type = buff.getBuff().getValue()[2];
        AttributeType attributeType = AttributeType.valueOf(type);
        target.getAttributeInfo().addOnceAttribute(attributeType, count * baseRate);
    }
}
