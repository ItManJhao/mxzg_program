package com.ayjs.mxzg.battle.buff.resurrection;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.stereotype.Component;

/**
 * 复活目标，如果目标没死则治疗
 */
@Component
public class ResurrectionBuffHandler extends AbstractResurrectionBuffHandler {


    @Override
    public BuffType getType() {
        return BuffType.BT_RESURRECTION;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
        if(defender.isDead()){
            int rebornAttackRate = buff.getValue()[0];
            resurrection(buff.getIdx(), rebornAttackRate, attacker, defender, context, builder);
        } else {
            int artId = buff.getValue()[1];
            battleService.executeBuffArt(artId, defender, attacker, context);
        }
        battleTrigger.trigger(BuffType.BT_PURE_HEART, attacker, defender, context);
    }

    @Override
    protected long replenishHP(int rebornAttackRate, HeroDo attacker, HeroDo defender) {
        long attack = attacker.getAttribute(AttributeType.ATTACK);
        return AttributeUtil.addPercent(attack, rebornAttackRate);
    }
}
