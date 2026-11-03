package com.ayjs.mxzg.battle.buff.resurrection;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 神佑，死亡后有一定概率复活，并回复指定生命值上限
 */
@Component
public class GodBlessBuffHandler extends LifeSavingBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_GOD_BLESS;
    }

}
