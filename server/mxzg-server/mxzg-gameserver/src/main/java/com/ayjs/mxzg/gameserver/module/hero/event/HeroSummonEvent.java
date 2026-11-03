package com.ayjs.mxzg.gameserver.module.hero.event;

import java.util.Collection;

import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.struct.SummonType;

import lombok.ToString;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@ToString
@Value(staticConstructor = "of")
public class HeroSummonEvent {
    private long rid;
    /**
     * 召唤类型
     */
    private SummonType type;
    /***
     * 召唤次数
     */
    private int summonCount;
    
    private Collection<Hero> heros;
}
