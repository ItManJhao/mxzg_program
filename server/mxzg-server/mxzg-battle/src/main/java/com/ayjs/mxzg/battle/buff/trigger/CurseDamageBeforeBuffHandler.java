package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

@Component
public class CurseDamageBeforeBuffHandler extends AbstractArtTriggerBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_CURE_DAMAGE_AFTER;
    }

}
