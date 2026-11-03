package com.ayjs.mxzg.battle.buff.attribute.state;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 强攻buff
 */
@Component
public class StormBuffHandler extends AbstractStateAttributeBuffHandler {
    @Override
    public BuffType getType() {
        return BuffType.BT_STORM;
    }
}
