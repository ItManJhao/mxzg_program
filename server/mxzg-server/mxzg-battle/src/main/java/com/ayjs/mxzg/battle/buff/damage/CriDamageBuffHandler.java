package com.ayjs.mxzg.battle.buff.damage;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.FightUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 必定暴击Buff处理器
 *
 * @author meiyc
 */
@Component
public class CriDamageBuffHandler extends AbstractDamageBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_CRI_DAMAGE;
    }

    @Override
    protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
        attacker.getAttributeInfo().setOnceAttribute(AttributeType.CRIT_PERCENT, 10000);
        defender.getAttributeInfo().setOnceAttribute(AttributeType.RESIST_CRIT_PERCENT, 0);
        return FightUtil.calDamage(buff, attacker, defender, false);
    }

}
