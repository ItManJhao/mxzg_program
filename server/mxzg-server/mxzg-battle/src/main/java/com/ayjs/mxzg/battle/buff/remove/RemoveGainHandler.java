package com.ayjs.mxzg.battle.buff.remove;

import com.ayjs.mxzg.battle.model.BuffDo;
import com.ayjs.mxzg.config.struct.BuffType;
import com.ayjs.mxzg.config.struct.EffectType;
import org.springframework.stereotype.Component;

/**
 * 移除增益
 *
 * @author tangyangbo
 */
@Component
public class RemoveGainHandler extends AbstractRemoveBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_REMOVE_BUFF;
    }

    @Override
    protected boolean isRemove(BuffDo buffDo) {
        return buffDo.getBuff().getEffecttype() == EffectType.GAIN;
    }

}
