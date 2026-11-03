package com.ayjs.mxzg.battle.buff.trigger;

import cn.hutool.core.util.RandomUtil;
import com.ayjs.mxzg.battle.model.*;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * 灵魂契约
 */
@Component
public class SoulContractBuffHandler extends AbstractArtTriggerBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_SOUL_CONTRACT;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, BattleGMsg.BuffInfo.Builder builder) {
        BattlerDo enemy = context.getEnemy(attacker.getFaction());
        HeroDo heroDo = RandomUtil.randomEle(enemy.getHeros());;
        BuffDo buffDo = addBuff(buff, attacker, defender, builder, context);
        if(Objects.nonNull(buffDo)){
            buffDo.setValue(heroDo.getUnitId());

            BattleGMsg.BuffInfo.Builder enemyBuff = BattleGMsg.BuffInfo.newBuilder();
            addBuff(buff, attacker, heroDo, enemyBuff, context);
            context.addUpdateBuff(enemyBuff.build());

            int buffId = buff.getValue()[2];
            if(buffId != 0){
                CBuff reverseBuff = buffSysCache.getOrThrow(buffId);

                BattleGMsg.BuffInfo.Builder buffBuilder = BattleGMsg.BuffInfo.newBuilder();
                BuffDo reverseBuffDo = addBuff(reverseBuff, attacker, heroDo, buffBuilder, context);
                reverseBuffDo.setValue(defender.getUnitId());
                context.addUpdateBuff(buffBuilder.build());
            }
        }
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        if(buff.getValue() == 0){
            return;
        }

        HeroDo contractor = context.getHero((int)buff.getValue());
        if(contractor.isDead()){
            return;
        }

        HeroDo source = context.getHero(buff.getSourceId());

        DamageResult result = target.getResult();
        int rate = buff.getBuff().getValue()[0];
        long damage = AttributeUtil.addPercent(result.getDamage(), rate);
        result.updateDamage(Math.abs(damage));

        DamageResult damageResult = DamageResult.createRealDamage(damage);
        CBuff reverseBuff = buffSysCache.getOrThrow(result.getBuffId());
        addDamageBuff(reverseBuff, damageResult, source, contractor, context);
    }
}
