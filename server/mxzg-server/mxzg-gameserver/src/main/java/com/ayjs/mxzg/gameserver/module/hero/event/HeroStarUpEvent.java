package com.ayjs.mxzg.gameserver.module.hero.event;

import java.util.List;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/10/23
 **/
@Value(staticConstructor = "of")
public class HeroStarUpEvent {
    /**
     * 升星
     */
    private Hero hero;
    private GameEvent gameEvent;
    private int oriStar;
    private List<ImmutableThing> costList;
    private List<ImmutableThing> rewardList;
    private List<Hero> deteleHeros;
}
