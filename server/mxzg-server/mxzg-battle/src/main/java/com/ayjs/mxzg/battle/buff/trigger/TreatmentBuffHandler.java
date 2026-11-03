package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 治疗buff
 */
@Component
public class TreatmentBuffHandler extends AbstractArtTriggerBuffHandler{
    @Override
    public BuffType getType() {
        return BuffType.BT_TREATMENT;
    }

}
