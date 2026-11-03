package com.ayjs.mxzg.battle.buff.attribute.state;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 狂暴
 */
@Component
public class ViolentBuffHandler extends AbstractStateAttributeBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_VIOLENT;
    }
}
