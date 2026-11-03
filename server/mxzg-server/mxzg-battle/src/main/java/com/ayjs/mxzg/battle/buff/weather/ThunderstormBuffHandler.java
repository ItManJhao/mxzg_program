package com.ayjs.mxzg.battle.buff.weather;

import com.ayjs.mxzg.config.struct.BuffType;
import org.springframework.stereotype.Component;

/**
 * 雷暴
 */
@Component
public class ThunderstormBuffHandler extends AbstractStatusBuffHandler {

    @Override
    public BuffType getType() {
        return BuffType.BT_THUNDERSTORM;
    }


}
