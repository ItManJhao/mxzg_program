package com.ayjs.mxzg.gameserver.module.hero.service;


import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.HeroFashionSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroFashion;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.hero.dao.HeroFashionDao;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroFashion;
import com.ayjs.mxzg.gameserver.module.hero.event.FashionActiveEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.FashionExpiresEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSwitchEvent;
import com.ayjs.mxzg.gameserver.module.hero.struct.FashionData;
import com.ayjs.mxzg.gameserver.module.prophetSummon.event.HeroChangeAffirmEvent;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.HeroFashionGMsg;
import com.ayjs.mxzg.protocol.RoleGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 英雄皮肤（时装）
 *
 * @author hyx
 */
@Service
@Observer
public class HeroFashionService {

    @Autowired
    private HeroFashionDao heroFashionDao;
    @Autowired
    private HeroService heroService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private HeroFashionSysCache heroFashionSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private ContextManager contextManager;

    /**
     * 刷新清除过期皮肤
     *
     * @param rid
     * @return
     */
    public HeroFashion selectAndRefresh(long rid) {
        List<Integer> fashionList = new ArrayList<>();
        HeroFashion heroFashion = heroFashionDao.get(rid);
        if (heroFashion == null) {
            heroFashion = new HeroFashion();
            heroFashion.setRid(rid);
            heroFashionDao.add(heroFashion);
        } else {
            List<FashionData> dataList = heroFashion.getFashionList().stream().
                    filter(fashionData -> fashionData.getStatus() == 1 && fashionData.getTimeLimit() < DateTimeUtil.currentSecond()).collect(Collectors.toList());

            //有过期皮肤
            if (dataList.size() > 0) {
                //添加过期的皮肤id
                for (FashionData fashionData : dataList) {
                    fashionList.add(fashionData.getFashionId());
                }
                //更新
                heroFashion.getFashionList().removeAll(dataList);
                heroFashionDao.update(heroFashion);
            }

            //存在过期皮肤
            if (!fashionList.isEmpty()) {
                //若有英雄装备该皮肤
                for (Hero hero : heroService.getHeros(rid)) {
                    if (fashionList.contains(hero.getFashionId())) {
                        hero.setFashionId(0);
                        heroService.updateHero(hero);
                    }
                }

                //抛出皮肤过期事件
                eventBus.post(FashionExpiresEvent.of(rid, fashionList, GameEvent.HERO_FASHION_EXPIRES));
            }
        }

        return heroFashion;
    }

    /**
     * 获取指定英雄类型皮肤集
     *
     * @param rid
     * @param hero_type
     */
    public List<FashionData> selectHeroType(long rid, int hero_type) {

        HeroFashion heroFashion = this.selectAndRefresh(rid);

        List<FashionData> fashionDataList = new ArrayList<>();
        for (FashionData fashionData : heroFashion.getFashionList()) {

            CHeroFashion cHeroFashion = heroFashionSysCache.getOrThrow(fashionData.getFashionId());
            if (cHeroFashion.getHero_type() == hero_type) {
                fashionDataList.add(fashionData);
            }

        }
        return fashionDataList;
    }

    /**
     * 获取指定皮肤数据
     *
     * @param heroFashion
     * @param fashionId
     * @return
     */
    public FashionData selectFashionData(HeroFashion heroFashion, int fashionId) {
        FashionData fashionData = null;
        for (FashionData data : heroFashion.getFashionList()) {
            if (data.getFashionId() == fashionId) {
                fashionData = data;
            }
        }
        return fashionData;
    }


    public void update(HeroFashion heroFashion) {
        heroFashionDao.update(heroFashion);
    }

    public HeroFashion add(long rid) {
        HeroFashion heroFashion = new HeroFashion();
        heroFashion.setRid(rid);
        heroFashionDao.add(heroFashion);
        return heroFashion;
    }

    public HeroFashionGMsg.GResHeroFashionList.Builder sendActiveFashion(long rid) {
        HeroFashionGMsg.GResHeroFashionList.Builder builder = HeroFashionGMsg.GResHeroFashionList.newBuilder();

        HeroFashion heroFashion = this.selectAndRefresh(rid);

        heroFashion.getFashionList().forEach(fashionData -> {
            HeroFashionGMsg.PSFashionData.Builder data = HeroFashionGMsg.PSFashionData.newBuilder();
            CHeroFashion config = heroFashionSysCache.getOrThrow(fashionData.getFashionId());
            data.setHeroType(config.getHero_type());
            data.setFashionId(fashionData.getFashionId());
            data.setLevel(fashionData.getLevel());
            data.setStatus(fashionData.getStatus());
            data.setEndTime(fashionData.getTimeLimit());
            builder.addList(data);
        });

        return builder;
    }

    public HeroFashionGMsg.GResHeroFashion.Builder sendHeroFashion(long rid) {
        HeroFashionGMsg.GResHeroFashion.Builder builder = HeroFashionGMsg.GResHeroFashion.newBuilder();
        List<Hero> heroList = heroService.getHeros(rid);
        heroList.stream().filter(hero -> hero.getFashionId() > 0).forEach(hero -> {
            HeroFashionGMsg.PSHeroFashion.Builder data = HeroFashionGMsg.PSHeroFashion.newBuilder();
            data.setHeroId(hero.getId());
            data.setFashionId(hero.getFashionId());
            builder.addList(data);
        });
        return builder;
    }

    @Subscribe
    public void listen(FashionActiveEvent event) {
        HeroFashionGMsg.GResHeroFashionList.Builder builder = this.sendActiveFashion(event.getRid());
        contextManager.write(event.getRid(), CmdCode._4402, builder.build());
    }

    @Subscribe
    public void listen(HeroSwitchEvent event){
        HeroFashionGMsg.GResHeroFashion.Builder builder1 = this.sendHeroFashion(event.getHero().getRid());
        contextManager.write(event.getHero().getRid(), CmdCode._4401, builder1.build());
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(FashionExpiresEvent event) {
        Role role = roleService.getOrThrow(event.getRid());
        if (event.getFashionList().contains(role.getImageId())) {

            CHeroType cHeroType = heroTypeSysCache.getOrThrow(systemSysCache.getFirstOrdinaryLottery());
            String imageId = cHeroType.getStar() + "" + systemSysCache.getFirstOrdinaryLottery();

            role.setImageId(Integer.parseInt(imageId));
            roleService.updateRole(role);

            RoleGMsg.GResRoleChangeHead.Builder builder = RoleGMsg.GResRoleChangeHead.newBuilder();
            builder.setImageId(role.getImageId());
            contextManager.write(event.getRid(), CmdCode._2011, builder.build());
        }

        HeroFashionGMsg.GResHeroFashion.Builder builder1 = this.sendHeroFashion(event.getRid());
        contextManager.write(event.getRid(), CmdCode._4401, builder1.build());

        HeroFashionGMsg.GResHeroFashionList.Builder builder = this.sendActiveFashion(event.getRid());
        contextManager.write(event.getRid(), CmdCode._4402, builder.build());

    }

    @Subscribe
    private void listen(HeroChangeAffirmEvent event){
        HeroFashionGMsg.GResHeroFashion.Builder builder1 = this.sendHeroFashion(event.getRid());
        contextManager.write(event.getRid(), CmdCode._4401, builder1.build());
    }

    public List<Hero> getHeroList(long rid, int fashionId) {

        CHeroFashion cHeroFashion = heroFashionSysCache.getOrThrow(fashionId);

        return heroService.getHeros(rid).stream().
                filter(hero -> hero.getType() == cHeroFashion.getHero_type()).collect(Collectors.toList());
    }

}
