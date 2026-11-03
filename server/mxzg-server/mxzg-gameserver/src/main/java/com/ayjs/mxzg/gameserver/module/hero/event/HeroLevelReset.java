package com.ayjs.mxzg.gameserver.module.hero.event;

import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import lombok.Value;

/**
 * @Author CJX
 * @Date 2021/6/3
 */

@Value(staticConstructor = "of")
public class HeroLevelReset {
    private Hero hero;
}
