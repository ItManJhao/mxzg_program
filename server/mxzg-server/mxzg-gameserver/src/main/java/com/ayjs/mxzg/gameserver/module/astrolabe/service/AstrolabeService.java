package com.ayjs.mxzg.gameserver.module.astrolabe.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.astrolabe.dao.AstrolabeDao;
import com.ayjs.mxzg.gameserver.module.astrolabe.domain.Astrolabe;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.LineUpChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.protocol.AstrolabeGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 星盘
 *
 * @Author: CWJ
 * @Date: 2020/4/27
 **/
@Service
@Observer
public class AstrolabeService {
    @Autowired
    private AstrolabeDao astrolabeDao;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private ContextManager contextManager;


    public Astrolabe load(long rid) {
        Astrolabe astrolabe = astrolabeDao.get(rid);
        if (astrolabe == null) {
            astrolabe = new Astrolabe();
            astrolabe.setRid(rid);
            astrolabeDao.add(astrolabe);
        }
        return astrolabe;
    }

    public void update(Astrolabe astrolabe) {
        astrolabeDao.update(astrolabe);
    }

    @Subscribe
    public void listen(LineUpChangeEvent event) {
        if (event.getHeroLineUp().getType() != LineUpType.MAIN.getValue()) {
            return;
        }
        tryUpdateMaxStar(event.getHeroLineUp());
    }

    @Subscribe
    public void listen(HeroStarUpEvent event) {
        long rid = event.getHero().getRid();
        HeroLineUp mainLineUp = heroLineUpService.getLineUpByType(rid, LineUpType.MAIN);
        if (!mainLineUp.getFormationMap().containsKey(event.getHero().getId())) {
            return;
        }
        tryUpdateMaxStar(mainLineUp);
    }

    private void tryUpdateMaxStar(HeroLineUp mainLineUp) {
        long rid = mainLineUp.getRid();
        int sumStar = 0;
        for (Long heroId : mainLineUp.getFormationMap().keySet()) {
            Hero hero = heroService.getHero(rid, heroId);
            sumStar += hero.getStar();
        }
        Astrolabe astrolabe = load(rid);
        if (sumStar > astrolabe.getMaxStar()) {
            astrolabe.setMaxStar(sumStar);
            update(astrolabe);

            AstrolabeGMsg.GResAstrolabeUpdateMaxStar.Builder builder = AstrolabeGMsg.GResAstrolabeUpdateMaxStar.newBuilder();
            builder.setMaxStar(sumStar);
            contextManager.write(rid, CmdCode._68005, builder.build());
        }
    }
}
