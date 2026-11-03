package com.ayjs.mxzg.battle.buff.remove;

import com.ayjs.mxzg.battle.buff.AbstractBaseDamageBuffHandler;
import com.ayjs.mxzg.battle.buff.BuffHelper;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.EffectType;
import com.ayjs.mxzg.protocol.BattleGMsg.BuffInfo.Builder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 移除增益buff，并根据移除buff的个数来
 *
 * @author meiyc
 */
@Component
public class DisperseDamageHandler extends AbstractBaseDamageBuffHandler {

    @Autowired
    private BuffHelper buffHelper;

    @Override
    public BuffType getType() {
        return BuffType.BT_DISPERSE_DAMAGE;
    }

    @Override
    public void handle(CBuff buff, HeroDo attacker, HeroDo defender, BattleContext context, Builder builder) {
        List<BuffDo> buffs = defender.getBuffsBy(EffectType.GAIN);
        buffs.forEach(buffDo -> {
            buffHelper.removeBuff(buffDo, defender, context);
        });

        if(buffs.isEmpty()){
            return;
        }

        int hpRatio = buff.getValue()[0];
        int attackLimit = buff.getValue()[1];
        long damage = AttributeUtil.addPercent(attacker.getHp(), hpRatio * buffs.size());
        long damageLimit = AttributeUtil.addPercent(attacker.getAttribute(AttributeType.ATTACK), attackLimit);
        damage = Math.min(damage, damageLimit);

        DamageResult result = DamageResult.createRealDamage(damage);
        addDamageBuff(buff, result, attacker, defender, context);
    }

}
