package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractBaseDamageBuffHandler;
import com.ayjs.mxzg.battle.buff.BuffHelper;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.service.BattleService;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 怒气强化，根据自己有多少层buff来执行后续的art，执行完后清除怒气
 */
@Component
public class AngerStrengthenBuffHandler extends AbstractBaseDamageBuffHandler {

    @Autowired
    private BattleService battleService;
    @Autowired
    private BuffHelper buffHelper;

    /** artId 的起始下标*/
    private final int ART_ID_START_INDEX  = 3;

    @Override
    public BuffType getType() {
        return BuffType.BT_ANGER_STRENGTHEN;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
        int layers = buff.getValue()[0];
        List<BuffDo> buffs = attacker.getBuffsBy(BuffType.BT_ANGER);
        int times = buffs.size() / layers;

        if(times <= 0) { return; }

        for(int artIndex = ART_ID_START_INDEX; artIndex < ART_ID_START_INDEX + times; artIndex++){
            if(artIndex < buff.getValue().length){
                int artId = buff.getValue()[artIndex];
                if(defender.isDead()){
                   break;
                }
                battleService.executeBuffArt(artId, defender, attacker, context);
            }
        }

        // 溅射
        int sputterNumber = buff.getValue()[1];
        int damageRatio = buff.getValue()[2];

        BattlerDo enemy = context.getEnemy(attacker.getFaction());
        List<HeroDo> allHeroes = enemy.getHeros();
        allHeroes.remove(defender);
        List<HeroDo> sputterTargets = RandomUtil.randomList(allHeroes, sputterNumber);
        DamageResult damageResult = attacker.getResult();
        for (HeroDo sputterTarget : sputterTargets) {
            long damage = damageResult.getInitialDamage();
            damage = AttributeUtil.addPercent(damage, damageRatio);
            DamageResult result = DamageResult.builder().fixedAttack(true).hitType(damageResult.getHitType()).buffId(damageResult.getBuffId()).damage(damage).build();
            addDamageBuff(buff, result, attacker, sputterTarget, context);
        }

        buffHelper.removeBuffs(buffs, attacker, context);
    }

}