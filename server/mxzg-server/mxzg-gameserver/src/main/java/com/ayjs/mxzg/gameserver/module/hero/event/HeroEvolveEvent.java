package com.ayjs.mxzg.gameserver.module.hero.event;

import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2020/7/21
 **/
@Value(staticConstructor = "of")
public class HeroEvolveEvent {
    private Hero hero;
}
