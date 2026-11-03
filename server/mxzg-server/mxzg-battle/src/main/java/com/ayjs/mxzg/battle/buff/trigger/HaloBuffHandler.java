package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.battle.model.*;
import com.ayjs.mxzg.battle.util.AttributeUtil;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.config.struct.Attribute;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 统计元素英雄个数
 */
@Component
public class HaloBuffHandler extends AbstractArtTriggerBuffHandler{
    @Override
    public BuffType getType() {
        return BuffType.BT_HALO;
    }


    @Override
    public void trigger(BuffDo buff, HeroDo beTrigger, HeroDo target, BattleContext context) {
        BattlerDo self = context.getSelf(beTrigger.getFaction());
        int element = buff.getBuff().getValue()[0];
        List<HeroDo> elementHeroes = self.getHeroByElem(element);

        int num = buff.getBuff().getValue()[1];
        int totalNum = elementHeroes.size() * num;
        if(totalNum > 0){
            int type = buff.getBuff().getValue()[2];
            AttributeType attributeType = ConvertUtils.toEnum(type, AttributeType.class);
            beTrigger.getAttributeInfo().addOnceAttribute(attributeType, totalNum);
        }
    }
}
