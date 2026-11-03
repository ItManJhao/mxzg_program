package com.ayjs.mxzg.gameserver.module.hero.event;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/3/15
 **/
@Value(staticConstructor = "of")
public class HeroEquipSoulChangeEvent {
    private Hero hero;
    private GameEvent gameEvent;
}
