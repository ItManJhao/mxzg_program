package com.ayjs.mxzg.gameserver.module.targetCounter.counter;

import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.targetCounter.dao.TaskTargetCountDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/10/28
 **/
@Controller
public class HadHighStarHeroCounter implements Counter {

    @Autowired
    private HeroService heroService;
    @Autowired
    private TaskTargetCountDao taskTargetCountDao;

    @Override
    public TargetType thisType() {
        return TargetType.HAD_HIGH_STAR_HERO;
    }

    @Override
    public int count(long rid, TargetStruct targetStruct) {
        List<Hero> heros = heroService.getHeros(rid);
        return (int) heros.stream().filter(hero -> hero.getStar() >= targetStruct.getCondition()).count();
    }

    @Override
    public long taskCount(long rid, TargetStruct targetStruct) {
        return count(rid, targetStruct);
    }
}
