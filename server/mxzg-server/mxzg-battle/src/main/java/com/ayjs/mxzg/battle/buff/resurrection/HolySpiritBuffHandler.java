package com.ayjs.mxzg.battle.buff.resurrection;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

import java.util.Optional;

/**
 *圣灵，每回合有概率复活,需要检测位置是否被援助英雄占据
 */
@Component
public class HolySpiritBuffHandler extends AbstractResurrectionBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_HOLY_SPIRIT;
    }


    @Override
    public void executeRound(BuffDo buff, HeroDo target, BattleContext context, Builder builder) {
        int rebornRate = buff.getBuff().getValue()[0];
        int roundRate = buff.getBuff().getValue()[1];
        int rebornRound = buff.getBuff().getValue()[2];
        boolean mustReborn = context.currentRound() == buff.getValue() + rebornRound;
        long totalRate = rebornRate + ((context.currentRound() - buff.getValue() - 1) * roundRate);
        double totalRebornRate = AttributeUtil.calPercent(totalRate);

        BattlerDo battlerDo = context.getSelf(target.getFaction());
        Optional<HeroDo> current = battlerDo.getHeros().stream().filter(heroDo -> heroDo.getPosition() == target.getPosition() && heroDo.getUnitId() != target.getUnitId()).findFirst();
        if(current.isPresent()){
            return;
        }

        if(mustReborn || RandomUtils.isHit(totalRebornRate)){
            buildBuff(buff.getBuff().getIdx(), target, builder, context);
            int rebornArtId = buff.getBuff().getValue()[3];
            battleService.executeBuffArt(rebornArtId, target, target, context);
            context.transferEffectToBuff();
            buffHelper.removeBuff(buff, target, context);
        }
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        if(target.haveBuff(BuffType.BT_EXORCISM)){
            buffHelper.removeBuff(buff, beTrigger, context);
            return;
        }
        buff.setValue(context.currentRound());
    }
}
