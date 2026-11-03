package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractBuffHandler;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.ContextType;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * 小熊
 *
 * @author meiyc
 */
@Component
public class LittleBearBuffHandler extends AbstractBuffHandler {
    @Override
    public BuffType getType() {
        return BuffType.BT_LITTLE_BEAR;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
        long cdRound = buff.getValue()[1];
        long deathRound = attacker.getContext(ContextType.BEAR_DEATH_ROUND);
        if(deathRound != 0 && context.getRound().get() < deathRound + cdRound){
            return;
        }
        long maxHP = attacker.getAttributeInfo().getMaxHp();
        long hpRate = buff.getValue()[0];
        BuffDo buffDo = addBuff(buff, attacker, attacker, builder, context);
        long bearHp = AttributeUtil.addPercent(maxHP, hpRate);
        buffDo.setValue(bearHp);
    }

}
