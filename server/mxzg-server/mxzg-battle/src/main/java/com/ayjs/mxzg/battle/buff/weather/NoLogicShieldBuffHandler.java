package com.ayjs.mxzg.battle.buff.weather;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 无状态护盾
 */
@Component
public class NoLogicShieldBuffHandler extends AbstractStatusBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_NO_LOGIC_SHIELD;
    }


}
