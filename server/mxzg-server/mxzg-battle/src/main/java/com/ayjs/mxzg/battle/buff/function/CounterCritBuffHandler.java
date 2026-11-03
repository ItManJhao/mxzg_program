package com.ayjs.mxzg.battle.buff.function;

import com.ayjs.mxzg.battle.buff.AbstractDebuffHandler;
import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 抗暴
 */
@Component
public class CounterCritBuffHandler extends AbstractDebuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_COUNTER_CRIT;
    }

}
