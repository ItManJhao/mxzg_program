package com.ayjs.mxzg.battle.buff.damage;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.FightUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 速度加成伤害
 *
 * @author meiyc
 */
@Component
public class SpeedDamageBuffHandler extends AbstractDamageBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_SPEED_DAMAGE;
    }

    @Override
    protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
        DamageResult result = FightUtil.calDamage(buff, attacker, defender, false);
        int speedLimit = buff.getValue()[2];
        long speed = attacker.getSpeed();
        double addRate = (double)speed / (speed + speedLimit);
        long addDamage = (long)(result.getDamage() * addRate);
        result.updateDamage(addDamage);
        return result;
    }

}