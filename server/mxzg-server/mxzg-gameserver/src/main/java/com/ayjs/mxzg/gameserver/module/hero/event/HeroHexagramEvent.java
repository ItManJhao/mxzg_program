package com.ayjs.mxzg.gameserver.module.hero.event;

import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import lombok.Value;

/**
 * @Author CJX
 * @Date 2021/5/21
 */

@Value(staticConstructor = "of")
public class HeroHexagramEvent {
    private Hero hero;
}
