package com.ayjs.mxzg.gameserver.module.hero.event;

import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/1/29
 **/
@Value(staticConstructor = "of")
public class HeroAwakenSelectEvent {
    private Hero hero;
}
