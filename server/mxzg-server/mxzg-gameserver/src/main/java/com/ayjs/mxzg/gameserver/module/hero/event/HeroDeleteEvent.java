package com.ayjs.mxzg.gameserver.module.hero.event;

import java.util.List;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/10/28
 **/
@Value(staticConstructor = "of")
public class HeroDeleteEvent {

    private long rid;
    private List<Hero> heros;
    private GameEvent gameEvent;
}
