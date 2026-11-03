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
 * 勤王
 *
 * @author meiyc
 */
@Component
public class CaptureKingBuffHandler extends AbstractDamageBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_CAPTURE_KING;
    }

    @Override
    protected DamageResult calDamage(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context) {
        long hp = defender.getHp();
        DamageResult result = DamageResult.createRealDamage(-hp);
        context.heroHurt(defender, attacker, result, 0);
        return result;
    }

}
