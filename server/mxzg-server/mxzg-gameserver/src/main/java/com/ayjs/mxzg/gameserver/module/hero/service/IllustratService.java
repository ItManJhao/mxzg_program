/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.hero.dao.IllustratDao;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.Illustrat;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.struct.IllustratData;
import com.ayjs.mxzg.protocol.HeroGMsg.GResIllustratActive;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * @author YY
 *
 */
@Observer
@Service
public class IllustratService {

    @Autowired
    private IllustratDao illustratDao;
    @Autowired
    private ContextManager contextManager;


    public Illustrat getIllustrat(long rid) {
        Illustrat illustrat = illustratDao.get(rid);
        if (illustrat == null) {
            illustrat = new Illustrat();
            illustrat.setRid(rid);
            illustrat.setHeros(new HashMap<>());
            illustratDao.add(illustrat);
        }
        return illustrat;
    }

    public void updateIllustrats(Illustrat illustrat) {
        illustratDao.update(illustrat);
    }

    /**
     * 添加图鉴
     * @param event
     */
    @Subscribe
    public void addIllustratRecv(HeroGetEvent event) {
        this.addIllustratRecv(event.getRid(), event.getHeros());
    }

    /**
     * 添加图鉴
     * @param event
     */
    @Subscribe
    public void addIllustratRecv(HeroStarUpEvent event) {
        List<Hero> heroList = new ArrayList<>();
        heroList.add(event.getHero());
        this.addIllustratRecv(event.getHero().getRid(), heroList);
    }

    private void addIllustratRecv(long rid, List<Hero> heroList) {
        Illustrat illustrat = getIllustrat(rid);

        List<IllustratData> noticeData = new ArrayList<>();

        for (Hero hero : heroList) {
            IllustratData illustratData = illustrat.getHeros().get(hero.getType());
            if (illustratData == null) {
                illustratData = new IllustratData();
                illustratData.setHeroType(hero.getType());
                illustrat.getHeros().put(hero.getType(), illustratData);
            }
            if (hero.getStar() > illustratData.getStar()) {
                illustratData.setStar(hero.getStar());
                noticeData.add(illustratData);
            }
        }
        updateIllustrats(illustrat);

        for (IllustratData illustratData : noticeData) {
            GResIllustratActive.Builder builder = GResIllustratActive.newBuilder();
            builder.setHeroType(illustratData.getHeroType());
            builder.setStar(illustratData.getStar());
            contextManager.write(rid, CmdCode._4014, builder.build());
        }
    }
}
