package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * 护盾buff
 */
@Component
public class ShieldBuffHandler extends AbstractArtTriggerBuffHandler {
    @Override
    public BuffType getType() {
        return BuffType.BT_SHIELD;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, BattleGMsg.BuffInfo.Builder builder) {
        int treatmentConversionRatio = buff.getValue()[0];
        int damageConversionRatio = buff.getValue()[1];
        int hpConversionRatio = buff.getValue()[2];
        int attackConversionRatio = buff.getValue()[3];
        int shieldConversionRatio;
        long convertBaseValue = 0;
        if(treatmentConversionRatio != 0){
            convertBaseValue = attacker.getLastTreatmentValue();
            shieldConversionRatio = treatmentConversionRatio;
        } else if(damageConversionRatio != 0){
            shieldConversionRatio = damageConversionRatio;
            DamageResult result = attacker.getResult();
            if(result != null && !attacker.getResult().isMiss()){
                convertBaseValue = attacker.getResult().getTotalDamage();
            }
        } else if(hpConversionRatio != 0) {
            convertBaseValue = attacker.getAttributeInfo().getMaxHp();
            shieldConversionRatio = hpConversionRatio;
        } else {
            convertBaseValue = attacker.getAttributeInfo().getAttack();
            shieldConversionRatio = attackConversionRatio;
        }

        long shieldValue = (long)AttributeUtil.calPercent(convertBaseValue, shieldConversionRatio);
        BuffDo shieldBuff = addBuff(buff, attacker, defender, builder, context);
        if (Objects.nonNull(shieldBuff)) {
            shieldBuff.setValue(Math.abs(shieldValue));
        }
    }

}
