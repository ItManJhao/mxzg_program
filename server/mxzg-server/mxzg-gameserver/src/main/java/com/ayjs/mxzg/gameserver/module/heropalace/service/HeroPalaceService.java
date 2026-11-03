package com.ayjs.mxzg.gameserver.module.heropalace.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.LocalDateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.HeroPalaceSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroPalace;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroStarUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.heropalace.dao.HeroPalaceDao;
import com.ayjs.mxzg.gameserver.module.heropalace.dao.HeroPalaceSelfDao;
import com.ayjs.mxzg.gameserver.module.heropalace.domain.HeroPalace;
import com.ayjs.mxzg.gameserver.module.heropalace.domain.HeroPalaceSelf;
import com.ayjs.mxzg.gameserver.module.marquee.service.MarqueeService;
import com.ayjs.mxzg.gameserver.module.marquee.struct.ObjParam;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/3/24
 **/
@Service
@Observer
public class HeroPalaceService {
    @Autowired
    private HeroPalaceDao heroPalaceDao;
    @Autowired
    private HeroPalaceSelfDao heroPalaceSelfDao;
    @Autowired
    private HeroPalaceSysCache heroPalaceSysCache;
    @Autowired
    private MarqueeService marqueeService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private HeroService heroService;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private RoleService roleService;

    private static final String HERO_PALACE_LOCK = "hero_palace_lock";

    public HeroPalace loadPalace(int type) {
        HeroPalace heroPalace = heroPalaceDao.getByType(type);
        if (heroPalace == null) {
            synchronized (InternerPool.intern(HERO_PALACE_LOCK, type)) {
                heroPalace = heroPalaceDao.getByType(type);
                if (heroPalace == null) {
                    heroPalace = new HeroPalace();
                    heroPalace.setType(type);
                    heroPalaceDao.add(heroPalace);
                }
            }
        }
        return heroPalace;
    }

    public HeroPalaceSelf loadPalaceSelf(long rid) {
        HeroPalaceSelf heroPalaceSelf = heroPalaceSelfDao.get(rid);
        int dayBreak = DateTimeUtil.dayBreak();
        if (heroPalaceSelf == null) {
            heroPalaceSelf = new HeroPalaceSelf();
            heroPalaceSelf.setRid(rid);
            heroPalaceSelf.setWorshipTimeData(DateTimeUtil.tomorrowBreak());
            heroPalaceSelf.setWorshipTime(LocalDate.now().plusDays(1));
            heroPalaceSelfDao.add(heroPalaceSelf);
        } else {
            if (heroPalaceSelf.getWorshipTimeData() <= 0) {
                LocalDate worshipTime = heroPalaceSelf.getWorshipTime();
                heroPalaceSelf.setWorshipTimeData(LocalDateTimeUtil.toEpochSecond(worshipTime));
            }
        }
        int worshipTimeData = heroPalaceSelf.getWorshipTimeData();
        if (worshipTimeData < dayBreak) {
            heroPalaceSelf.setWorshipType(new HashSet<>());
            heroPalaceSelf.setWorshipTimeData(DateTimeUtil.tomorrowBreak());
            heroPalaceSelf.setWorshipTime(LocalDate.now().plusDays(1));
            heroPalaceSelfDao.update(heroPalaceSelf);
        }
        return heroPalaceSelf;
    }

    public void update(HeroPalace heroPalace) {
        heroPalaceDao.update(heroPalace);
    }

    public void update(HeroPalaceSelf heroPalaceSelf) {
        heroPalaceSelfDao.update(heroPalaceSelf);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(HeroStarUpEvent event) {
        Hero hero = event.getHero();
        CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
        tryAddRank(cHeroType.getElem(), hero.getStar(), hero.getRid());
        tryAddTotalRank(hero.getStar(), hero.getRid());
    }

    private void tryAddTotalRank(int star, long rid) {
        List<CHeroPalace> elemList = heroPalaceSysCache.getAllByElem(0);
        if (CollectionUtil.isNotEmpty(elemList)) {
            CHeroPalace config = elemList.get(0);
            Role role = roleService.getOrThrow(rid);
            HeroPalace heroPalace = loadPalace(config.getType());
            List<Long> serverRankIds = heroPalace.getRankRid().stream()
                    .filter(ridTemp -> roleService.getOrThrow(ridTemp).getServerId() == role.getServerId()).collect(Collectors.toList());

            if (serverRankIds.size() >= elemList.size() ||
                    heroPalace.getRankRid().contains(rid) || config.getStar() != star) {
                return;
            }

            HeroPalaceSelf heroPalaceSelf = loadPalaceSelf(rid);
            int newValue = (int) heroService.getHeros(rid).stream().filter(hero -> hero.getStar() >= config.getStar()).count();
            if (heroPalaceSelf.getHeroNum().getOrDefault(config.getType(), 0) >= newValue) {
                return;
            }
            heroPalaceSelf.getHeroNum().put(config.getType(), newValue);
            update(heroPalaceSelf);

            if (newValue < config.getNum()) {
                return;
            }
            synchronized (InternerPool.intern(HERO_PALACE_LOCK, heroPalace.getType())) {
                 serverRankIds = heroPalace.getRankRid().stream()
                        .filter(ridTemp -> roleService.getOrThrow(ridTemp).getServerId() == role.getServerId()).collect(Collectors.toList());
                if (serverRankIds.size() < elemList.size() &&
                        !heroPalace.getRankRid().contains(rid)) {
                    heroPalace.getRankRid().add(rid);
                    update(heroPalace);
                    marqueeService.addMarquee(config.getNotice(), rid, ObjParam.build(rid, heroPalace.getRankRid().size()));
                }
            }
        }
    }

    private void tryAddRank(int elem, int star, long rid) {
        List<CHeroPalace> elemList = heroPalaceSysCache.getAllByElem(elem);
        if (CollectionUtil.isNotEmpty(elemList)) {
            CHeroPalace config = elemList.get(0);
            Role role = roleService.getOrThrow(rid);
            HeroPalace heroPalace = loadPalace(config.getType());
            HeroPalaceSelf heroPalaceSelf = loadPalaceSelf(rid);
            int newValue = heroPalaceSelf.getHeroNum().getOrDefault(config.getType(), 0) + 1;
            heroPalaceSelf.getHeroNum().put(config.getType(), newValue);
            update(heroPalaceSelf);
            List<Long> serverRankIds = heroPalace.getRankRid().stream()
                    .filter(ridTemp -> roleService.getOrThrow(ridTemp).getServerId() == role.getServerId()).collect(Collectors.toList());

            if (serverRankIds.size() >= elemList.size() ||
                    heroPalace.getRankRid().contains(rid) || config.getStar() != star) {
                return;
            }
            if (newValue < config.getNum()) {
                return;
            }
            synchronized (InternerPool.intern(HERO_PALACE_LOCK, heroPalace.getType())) {
                serverRankIds = heroPalace.getRankRid().stream()
                        .filter(ridTemp -> roleService.getOrThrow(ridTemp).getServerId() == role.getServerId()).collect(Collectors.toList());
                if (serverRankIds.size() < elemList.size() &&
                        !heroPalace.getRankRid().contains(rid)) {
                    heroPalace.getRankRid().add(rid);
                    update(heroPalace);
                    marqueeService.addMarquee(config.getNotice(), rid, ObjParam.build(rid, heroPalace.getRankRid().size()));
                }
            }
        }
    }
}
