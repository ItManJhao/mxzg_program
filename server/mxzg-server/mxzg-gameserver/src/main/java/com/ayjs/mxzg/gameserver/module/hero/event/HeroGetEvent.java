package com.ayjs.mxzg.gameserver.module.hero.event;

import java.util.List;

import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;

import lombok.Value;

/**
 * 获得英雄
 *
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class HeroGetEvent {
    private long rid;

    private List<Hero> heros;
    
    private GameEvent gameEvent;
    
//    //获得英雄星级
//    private int star;
//    //获得英雄数量
//    private int count;
}
