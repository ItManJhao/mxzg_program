package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.BuffHelper;
import com.ayjs.mxzg.battle.buff.trigger.AbstractArtTriggerBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;
import java.util.Optional;

/**
 * 光之力，叠加buff，叠加到指定层数后触发art
 */
@Component
public class PowerOfLightBuffHandler extends AbstractArtTriggerBuffHandler {

    @Autowired
    private BuffHelper buffHelper;

    @Override
    public BuffType getType() {
        return BuffType.BT_POWER_OF_LIGHT;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, BattleGMsg.BuffInfo.Builder builder) {
        Optional<BuffDo> exitsBuff = defender.getBuffBy(buff.getType(), attacker.getUnitId());
        BuffDo buffDo = null;
        if(exitsBuff.isPresent()){
            buffDo = exitsBuff.get();
            buffDo.buildBaseTo(builder);
        } else {
            buffDo = super.addBuff(buff, attacker, defender, builder, context);
        }
        if (Objects.nonNull(buffDo)) {
            buffDo.addValue(1);
            int triggerLayers = buff.getValue()[0];
            if (buffDo.getValue() >= triggerLayers) {
                trigger(buffDo, defender, attacker, context);
                buffHelper.removeBuff(buffDo, defender, context);
            }
        }
    }
}
