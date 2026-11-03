package com.ayjs.mxzg.gameserver.module.totems.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.totems.dao.TotemsDao;
import com.ayjs.mxzg.gameserver.module.totems.domain.Totems;
import com.ayjs.mxzg.gameserver.module.totems.event.TotemsAddEvent;
import com.ayjs.mxzg.gameserver.module.totems.event.TotemsOpreaEvent;
import com.ayjs.mxzg.gameserver.module.totems.event.TotemsResetEvent;
import com.ayjs.mxzg.gameserver.module.totems.event.TotemsUpEvent;
import com.ayjs.mxzg.protocol.TotemsGMsg;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Observer
@Service
public class TotemsService {

    @Autowired
    private TotemsDao totemsDao;
    @Autowired
    private ContextManager contextManager;

    @Autowired
    private HeroService heroService;

    public void addTotems(Totems totems) {
        totemsDao.add(totems);
    }

    public void updateTotems(Totems totems) {
        totemsDao.update(totems);
    }

    public List<Totems> getTotemsList(long rid) {
        return totemsDao.list("rid", rid);
    }


    /**
     * 获取角色指定的图腾
     *
     * @param rid
     * @param totems_id
     * @return
     */
    public Totems getTotems_byTotemsId(long rid, int totems_id) {
        List<Totems> totemsList = getTotemsList(rid);
        Totems totems = null;
        for (Totems myTotems : totemsList) {
            if (myTotems.getTotems_id() == totems_id) {
                totems = myTotems;
            }
        }
        return totems;
    }

    /**
     * 获取指定英雄的图腾
     *
     * @param rid
     * @param heroId
     * @return
     */
    public Totems getTotems_byHero(long rid, long heroId) {
        List<Totems> totemsList = getTotemsList(rid);
        Totems totems = null;
        for (Totems myTotems : totemsList) {
            if (myTotems.getHeroId() == heroId && heroId > 0) {
                totems = myTotems;
            }
        }
        return totems;
    }

    /**
     * 获取指定tId的图腾
     *
     * @param rid
     * @param tId
     * @return
     */
    public Totems getTotems_byId(long rid, long tId) {
        List<Totems> totemsList = getTotemsList(rid);
        Totems totems = null;
        for (Totems myTotems : totemsList) {
            if (myTotems.getId() == tId && tId > 0) {
                totems = myTotems;
            }
        }
        return totems;
    }

    //新增图腾
    @Subscribe
    public void listen(TotemsAddEvent event) {
        TotemsGMsg.GResAddTotemsInfo.Builder builder = TotemsGMsg.GResAddTotemsInfo.newBuilder();
        for (Totems totems : event.getTotemsList()) {
            builder.addList(builderTotemsInfo(totems));
        }
        contextManager.write(event.getRid(), CmdCode._74304, builder.build());
    }

    //图腾升级
    @Subscribe
    public void listen(TotemsUpEvent event) {
        Totems totems =  getTotems_byId(event.getRid(),event.getTId());
        if(totems.getHeroId()>0){
            Hero hero = heroService.getHero(event.getRid(), totems.getHeroId());
            heroService.computeStrength(hero, GameEvent.TOTEMS_UP_BATTLE);
        }
    }

    //图腾操作
    @Subscribe
    public void listen(TotemsOpreaEvent event) {
        Hero hero = heroService.getHero(event.getRid(), event.getHeroId());
        heroService.computeStrength(hero, GameEvent.TOTEMS_OPREA_BATTLE);
    }

    //图腾重置
    @Subscribe
    public void listen(TotemsResetEvent event) {
        Totems totems =  getTotems_byId(event.getRid(),event.getTId());
        if(totems.getHeroId()>0){
            Hero hero = heroService.getHero(event.getRid(), totems.getHeroId());
            heroService.computeStrength(hero, GameEvent.TOTEMS_RESET_BATTLE);
        }
    }

    //组装图腾消息体
    public TotemsGMsg.PSTotemsInfo builderTotemsInfo(Totems totems) {
        TotemsGMsg.PSTotemsInfo.Builder data = TotemsGMsg.PSTotemsInfo.newBuilder();
        data.setHeroId(totems.getHeroId());
        data.setSysId(totems.getTotems_id());
        data.setLevel(totems.getLevel());
        data.setQuality(totems.getQuality());
        data.setTId(totems.getId());
        return data.build();
    }
}
