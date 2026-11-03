package com.ayjs.mxzg.battle.buff.resurrection;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 保命，死亡时有概率复活，并回复少量生命值
 */
@Component
public class LifeSavingBuffHandler extends AbstractResurrectionBuffHandler {


    @Override
    public BuffType getType() {
        return BuffType.BT_LIFE_SAVING;
    }


    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        int resurrectionRatio = buff.getBuff().getValue()[0];
        double rate = AttributeUtil.calPercent(resurrectionRatio);
        if(RandomUtils.isHit(rate)){
            int rebornArtId = buff.getBuff().getValue()[1];
            battleService.executeBuffArt(rebornArtId, beTrigger, beTrigger, context);
            buff.addValue(1);
            int times = buff.getBuff().getValue()[2];
            if(times != 0 && buff.getValue() >= times){
                buffHelper.removeBuff(buff, beTrigger, context);
            }
        }
    }

}
