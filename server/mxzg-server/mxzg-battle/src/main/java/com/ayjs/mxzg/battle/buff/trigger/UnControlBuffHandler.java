package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.buff.BuffHelper;
import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.service.BattleService;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.EffectType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 被控制时触发
 */
@Component
public class UnControlBuffHandler extends AbstractArtTriggerBuffHandler {

    @Autowired
    private BuffHelper buffHelper;
    @Autowired
    private BattleService battleService;

    @Override
    public BuffType getType() {
        return BuffType.BT_UN_CONTROL;
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        List<BuffDo> controls =  beTrigger.getBuffsBy(EffectType.CONTROL);
        if(controls.isEmpty()){
            return;
        }

        buffHelper.removeBuffs(controls, beTrigger, context);
        buffHelper.removeBuff(buff, beTrigger, context);
        List<BuffDo> deBuffs =  beTrigger.getBuffsBy(EffectType.DEBUFF);
        buffHelper.removeBuffs(deBuffs, beTrigger, context);

        for (Integer artId : buff.getBuff().getArt_list()) {
            battleService.executeBuffArt(artId, beTrigger, beTrigger, context);
        }
    }
}
