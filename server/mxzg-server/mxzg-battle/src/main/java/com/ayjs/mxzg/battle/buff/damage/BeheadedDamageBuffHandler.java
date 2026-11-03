package com.ayjs.mxzg.battle.buff.damage;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.HitType;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.battle.util.FightUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 斩杀Buff处理器
 *
 * @author meiyc
 */
@Component
public class BeheadedDamageBuffHandler extends AbstractDamageBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_BEHEADED;
    }

    @Override
    protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
       int beheadedHpLimit = buff.getValue()[2];
       double beheadedRatio = AttributeUtil.calPercent(beheadedHpLimit);
       if(beheadedRatio > defender.getHpRate()){
           return calAttackDamage(buff, attacker, defender);
       }

       int attackLimit = buff.getValue()[3];
       long damageUpLimit = AttributeUtil.addPercent(attacker.getAttribute(AttributeType.ATTACK), attackLimit);
       if(defender.getHp() < damageUpLimit){
           return DamageResult.builder().damage(-defender.getHp()).fixedAttack(true).hitType(HitType.BEHEADED).build();
       } else {
           return calAttackDamage(buff, attacker, defender);
       }
    }

    /**
     * 计算攻击伤害
     * @param buff
     * @param attacker
     * @param defender
     * @return
     */
    private DamageResult calAttackDamage(CBuff buff, HeroDo attacker, HeroDo defender){
        int attackRatio = buff.getValue()[0];
        double lossHpRatio = 1 - defender.getHpRate();
        int hpRatioParam = buff.getValue()[1];
        int skillDamageRatio = attackRatio + (int)(lossHpRatio * hpRatioParam);
        return FightUtil.calDamage(attackRatio + skillDamageRatio, attacker, defender, false);
    }

}
