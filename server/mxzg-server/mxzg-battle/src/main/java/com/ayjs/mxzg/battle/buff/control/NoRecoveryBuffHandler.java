package com.ayjs.mxzg.battle.buff.control;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 禁疗，不能被治疗
 */
@Component
public class NoRecoveryBuffHandler extends AbstractControlBuffHandler  {
    @Override
    public BuffType getType() {
        return BuffType.BT_NO_RECOVERY;
    }
}
