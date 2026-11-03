package com.ayjs.mxzg.battle.buff.trigger;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

@Component
public class AfterDamageBuffHandler extends AbstractArtTriggerBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_AFTER_DAMAGE;
    }
}
