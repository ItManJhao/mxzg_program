package com.ayjs.mxzg.battle.buff.damage;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.battle.util.FightUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 增加最大伤害buff处理器
 *
 * @author meiyc
 */
@Component
public class AddHpMaxDamageBuffHandler extends AbstractDamageBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_ADDITIONAL_HP_MAX_DAMAGE;
    }

    @Override
    protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
        DamageResult result = FightUtil.calDamage(buff, attacker, defender, false);
        int hpRate = buff.getValue()[2];
        long maxHp = defender.getAttributeInfo().getMaxHp();
        long addDamage = AttributeUtil.addPercent(maxHp, hpRate);

        long maxDamageRate = buff.getValue()[3];
        long maxDamage = AttributeUtil.addPercent(attacker.getAttribute(AttributeType.ATTACK), maxDamageRate);
        addDamage = Math.min(maxDamage, addDamage);
        result.updateDamage(-addDamage);
        return result;
    }

}
