package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.google.common.collect.Sets;
import org.springframework.stereotype.Component;

import java.util.Set;

/**
 * 反向契约
 */
@Component
public class ReverseContractBuffHandler extends AbstractArtTriggerBuffHandler {

    private Set<BuffType> conflictBuff = Sets.newHashSet(BuffType.BT_SOUL_CONTRACT, BuffType.BT_REVERSE_CONTRACT);

    @Override
    public BuffType getType() {
        return BuffType.BT_REVERSE_CONTRACT;
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        long treatmentValue = target.getLastTreatmentValue();
        int rate = buff.getBuff().getValue()[0];
        long transferValue = AttributeUtil.addPercent(treatmentValue, rate);
        target.updateLastTreatmentValue(-transferValue);

        HeroDo contractHero = context.getHero((int)buff.getValue());
        if(contractHero.isDead()){
            return;
        }

        HeroDo source = context.getHero(buff.getSourceId());

        transferValue = context.replenish(contractHero, source, transferValue);

        BattleGMsg.BuffInfo.Builder builder = BattleGMsg.BuffInfo.newBuilder();
        buildBuff(buff.getBuff().getIdx(), contractHero, builder, context);

        BattleGMsg.AttributeUpdate attributeUpdate = BattleGMsg.AttributeUpdate.newBuilder().setType(AttributeType.HP.getValue()).setValue(transferValue).build();
        builder.addUpdate(attributeUpdate);

        context.addUpdateBuff(builder.build());
    }
}
