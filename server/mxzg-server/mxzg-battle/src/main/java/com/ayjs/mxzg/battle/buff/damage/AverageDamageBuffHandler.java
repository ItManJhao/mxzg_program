package com.ayjs.mxzg.battle.buff.damage;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.battle.util.FightUtil;
import com.ayjs.mxzg.config.excel.cache.BuffSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 均摊伤害Buff处理器
 *
 * @author meiyc
 */
@Component
public class AverageDamageBuffHandler extends AbstractDamageBuffHandler {

    @Autowired
    private BuffSysCache buffSysCache;

    @Override
    public BuffType getType() {
        return BuffType.BT_AVERAGE_DAMAGE;
    }

    @Override
    protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
        int skillDamage = buff.getSkillDamageValue();
        int targetType = buff.getValue()[3];
        BattlerDo battler = context.getEnemy(attacker.getFaction());
        List<HeroDo> heroes = null;
        if (targetType == 1) {
            heroes = battler.getHeros().stream().filter(heroDo -> heroDo.isFront()).collect(Collectors.toList());
        }
        if (targetType == 2) {
            heroes = battler.getHeros().stream().filter(heroDo -> !heroDo.isFront()).collect(Collectors.toList());
        }

        if (CollectionUtils.isEmpty(heroes)) {
            heroes = battler.getHeros();
        }

        int attackRatio = buff.getValue()[2];
        int buffId = buff.getValues().size() >= 5 ? buff.getValue()[4] : 0;
        long damageLimit = AttributeUtil.addPercent(attacker.getAttribute(AttributeType.ATTACK), attackRatio);
        int averageDamage = skillDamage / heroes.size();
        DamageResult damageResult = null;
        long totalDamage = 0;
        for (HeroDo hero : heroes) {
            DamageResult result = FightUtil.calDamage(averageDamage, attacker, hero, false);
            result.setBuffId(buff.getIdx());

            if(result.getDamage() > damageLimit){
                result.setDamage(damageLimit);
            }

            if(hero == defender){
                damageResult = result;
            } else {
                attacker.addDamageResult(result);
                battleTrigger.triggerAttacker(buff, result, attacker, defender, context, null);
                addDamageBuff(buff, result, attacker, hero, context);
            }
            totalDamage += result.getDamage();

        }

        if (buffId != 0) {
            CBuff cBuff = buffSysCache.getOrThrow(buffId);
            List<BattleGMsg.BuffInfo> buffInfos = battleService.executeBuff(Sets.newHashSet(heroes), cBuff, attacker, context);
            BattleGMsg.EffectInfo effectInfo = BattleGMsg.EffectInfo.newBuilder().setBuffId(cBuff.getIdx()).addAllBuffInfo(buffInfos).build();
            context.addAllEffectInfo(Lists.newArrayList(effectInfo));
        }

        damageResult.setTotalDamage(totalDamage);
        damageResult.setInitialDamage(totalDamage);
        return damageResult;

    }

}
