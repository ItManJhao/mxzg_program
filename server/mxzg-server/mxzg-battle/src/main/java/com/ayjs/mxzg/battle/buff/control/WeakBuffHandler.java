package com.ayjs.mxzg.battle.buff.control;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 虚弱，
 */
@Component
public class WeakBuffHandler extends AbstractControlBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_WEAK;
    }
}
