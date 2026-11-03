package com.ayjs.mxzg.gameserver.module.godRelic.service;

import com.ayjs.mxzg.config.excel.constant.GodRelicConst;
import com.ayjs.mxzg.gameserver.module.godRelic.dao.GodRelicDao;
import com.ayjs.mxzg.gameserver.module.godRelic.dao.GodRelicLevelDao;
import com.ayjs.mxzg.gameserver.module.godRelic.domain.GodRelic;
import com.ayjs.mxzg.gameserver.module.godRelic.domain.GodRelicLevel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Service
public class GodRelicService {

    @Autowired
    private GodRelicDao godRelicDao;
    @Autowired
    private GodRelicConst godRelicConst;
    @Autowired
    private GodRelicLevelDao godRelicLevelDao;

    public GodRelic load(long rid) {
        GodRelic godRelic = godRelicDao.get(rid);
        if (godRelic == null) {
            godRelic = new GodRelic();
            godRelic.setRid(rid);
            godRelic.setMaxChapter(1);
            godRelic.setMaxLevel(0);
            godRelic.setResetTime(LocalDate.now());
            godRelic.setBuyCount(0);
            godRelic.setCanChallengeCount(godRelicConst.getGodRelicDailyFreeTimes());
            godRelicDao.add(godRelic);
        }
        if (!LocalDate.now().isEqual(godRelic.getResetTime())) {
            godRelic.setBuyCount(0);
            godRelic.setCanChallengeCount(godRelicConst.getGodRelicDailyFreeTimes());
            godRelic.setResetTime(LocalDate.now());
            godRelicDao.update(godRelic);
        }
        return godRelic;
    }

    public List<GodRelicLevel> loadAllGodRelicLevel(long rid) {
        return godRelicLevelDao.list("rid", rid);
    }

    public void update(GodRelicLevel godRelicLevel) {
        godRelicLevelDao.update(godRelicLevel);
    }

    public GodRelicLevel loadLevel(long rid, int chapter, int level) {
        GodRelicLevel godRelicLevel = loadAllGodRelicLevel(rid).stream().filter(godRelicLevelTemp -> godRelicLevelTemp.getLevel() == level &&
                godRelicLevelTemp.getChapter() == chapter).findFirst().orElse(null);
        if (godRelicLevel == null) {
            godRelicLevel = new GodRelicLevel();
            godRelicLevel.setRid(rid);
            godRelicLevel.setChapter(chapter);
            godRelicLevel.setLevel(level);
            godRelicLevelDao.add(godRelicLevel);
        }
        return godRelicLevel;
    }


    public void update(GodRelic godRelic) {
        godRelicDao.update(godRelic);
    }

    public List<GodRelic> getAll() {
        return godRelicDao.listAll();
    }

    public void updateList(List<GodRelicLevel> update) {
        godRelicLevelDao.update(update);
    }
}
