package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.BattleContext;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.EffectType;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 清心,使用治疗和复活时有概率随机清除一个英雄的所有负面状态
 */
@Component
public class PureHeartBuffHandler extends AbstractArtTriggerBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_PURE_HEART;
    }

    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        int rate = buff.getBuff().getValue()[0];
        if(RandomUtils.isHit(rate)){
            BattlerDo battlerDo = context.getSelf(beTrigger.getFaction());
            List<HeroDo> heroDos = battlerDo.getAllHeros().stream().filter(heroDo -> !heroDo.getBuffsBy(EffectType.DEBUFF).isEmpty()).collect(Collectors.toList());
            if(!heroDos.isEmpty()){
                int num = buff.getBuff().getValue()[1];
                heroDos = RandomUtil.randomList(heroDos, num);
                for(HeroDo heroDo : heroDos){
                    List<BuffDo> buffDos = heroDo.getBuffsBy(EffectType.DEBUFF);
                    buffHelper.removeBuffs(buffDos, heroDo, context);
                }
            }
        }
    }
}
