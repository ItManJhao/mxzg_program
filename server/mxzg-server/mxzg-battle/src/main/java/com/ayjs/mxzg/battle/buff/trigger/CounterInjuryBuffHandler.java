package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.DamageResult;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.excel.cache.BuffSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 反伤
 */
@Component
public class CounterInjuryBuffHandler extends AbstractArtTriggerBuffHandler {

    @Autowired
    private BuffSysCache buffSysCache;

    @Override
    public BuffType getType() {
        return BuffType.BT_COUNTER_INJURY;
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        int ratio = buff.getBuff().getValue()[0];
        double counterProbability = AttributeUtil.calPercent(ratio);
        if(RandomUtils.isHit(counterProbability)){
            int counterRatio = buff.getBuff().getValue()[1];
            DamageResult result = target.getResult();
            long damage = AttributeUtil.addPercent(result.getDamage(), counterRatio);
            DamageResult counterInjuryResult = DamageResult.createRealDamage(damage);
            if(result.getBuffId() != 0){
                CBuff damageBuff = buffSysCache.getOrThrow(result.getBuffId());
                addDamageBuff(damageBuff, counterInjuryResult, beTrigger, target, context);
            }
        }
    }
}
