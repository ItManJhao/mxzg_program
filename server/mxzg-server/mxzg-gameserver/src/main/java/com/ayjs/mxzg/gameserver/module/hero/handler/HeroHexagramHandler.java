package com.ayjs.mxzg.gameserver.module.hero.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.HeroHexagramSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroHexagram;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.countryWar.service.CountryWarService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroHexagramEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroHexagram;
import com.ayjs.mxzg.protocol.HeroHexagramGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @Author CJX
 * @Date 2021/5/19
 **/
@Slf4j
@Component
public class HeroHexagramHandler extends ProtocolHandler {

    @Autowired
    private HeroHexagramSysCache heroHexagramSysCache;
    @Autowired
    private HeroService heroService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private CountryWarService countryWarService;


    //重置六芒星
    @CMD(id = CmdCode._4501)
    public void resetHexagram(PlayerContext playerContext, HeroHexagramGMsg.GReqHeroHexagramReset req) {
        Hero hero = heroService.getHero(playerContext.getId(), req.getHeroId());
        Asserts.isTrue(hero != null,
                ErrorCode.HERO_NOT_EXIST.getValue(),
                () -> String.format("英雄{%s}不存在", req.getHeroId()));
        //判断国战开没，判断开的哪个类型
        int type = req.getType();
        HeroHexagram hexagramData = getHexagramData(type, hero);
        int level = hexagramData.getLevel();
        CHeroHexagram config = heroHexagramSysCache.getHeroHexagram(type, level);
        hexagramData.setLevel(0);
        heroService.updateHero(hero);
        ImmutableList<ImmutableThing> give_back = config.getGive_back();
        thingService.add(playerContext.getId(), give_back, GameEvent.HERO_HEXAGRAM_RESET, NoticeType.NORMAL);

        HeroHexagramGMsg.GResHeroHexagramReset.Builder builder = HeroHexagramGMsg.GResHeroHexagramReset.newBuilder();
        builder.setHeroId(req.getHeroId());
        builder.setType(type);
        playerContext.write(CmdCode._4501, builder.build());
        eventBus.post(HeroHexagramEvent.of(hero));
    }

    @CMD(id = CmdCode._4502)
    public void upgradeHexagram(PlayerContext playerContext, HeroHexagramGMsg.GReqHeroHexagramUpgrade req) {
        Hero hero = heroService.getHero(playerContext.getId(), req.getHeroId());
        Asserts.isTrue(hero != null,
                ErrorCode.HERO_NOT_EXIST.getValue(),
                () -> String.format("英雄{%s}不存在", req.getHeroId()));
        //判断国战开没，判断开的哪个类型
        int type = req.getType();
        checkType(type);
        int level = req.getLevel();
        //判断六芒星等级
        HeroHexagram hexagramData = getHexagramData(type, hero);
        Asserts.notNull(hexagramData, () -> String.format("英雄六芒星等级{%d},{%d}", hexagramData.getLevel(), level));
        if(hexagramData.getLevel() + 1 != level){
            log.debug("hexagramData level:{}", hexagramData.getLevel());
            return;
        }
//        Asserts.isTrue( hexagramData.getLevel() + 1 == level, ErrorCode.HERO_HEXAGRAM_LEVEL_ERROR.getValue(), ()-> String.format("heroid:{%s}六芒星等级异常,level:{%d}", req.getHeroId(), level) );
        //判断英雄星级
        CHeroHexagram config = heroHexagramSysCache.getHeroHexagram(type, hexagramData.getLevel());
        int needStar = config.getNeed_star();
        Asserts.isTrue(hero.getStar() >= needStar, ErrorCode.HERO_HEXAGRAM_STAR_LOW.getValue(), () -> String.format("heroid:{%s}还没有达到{%d}星级", req.getHeroId(), needStar));

        //判断消耗是否足够
        ImmutableList<ImmutableThing> cost = config.getCost();
        Asserts.isTrue(thingService.enough(playerContext.getId(), cost),
                ErrorCode.HERO_HEXAGRAM_NOT_ENOUGH.getValue(),
                () -> String.format("英雄{%s},六芒星类型{%d},等级{%d}", req.getHeroId(), type, level));
        //扣除消耗
        thingService.cost(playerContext.getId(), cost, GameEvent.HERO_HEXAGRAM_UPGRADE);

        //扣除消耗成功，更新等级
        hexagramData.setLevel(level);
        heroService.updateHero(hero);

        HeroHexagramGMsg.GResHeroHexagramUpgrade.Builder builder = HeroHexagramGMsg.GResHeroHexagramUpgrade.newBuilder();
        builder.setHeroId(req.getHeroId());
        builder.setType(type);
        builder.setLevel(level);
        playerContext.write(CmdCode._4502, builder.build());

        eventBus.post(HeroHexagramEvent.of(hero));
    }

    /**
     * 判断当前国战类型是否符合
     *
     * @param type
     */
    private void checkType(int type) {
        //判断国战开没，判断开的哪个类型
        int openType = countryWarService.getOpenType();
        Asserts.isTrue(openType != 0, ErrorCode.HERO_HEXAGRAM_TYPE_ERROR.getValue(),
                "国战未开启");
        Asserts.isTrue(openType == type, ErrorCode.HERO_HEXAGRAM_TYPE_ERROR.getValue(),
                () -> String.format("开启的类型不一致opentype={%d},type={%d}", openType, type));
    }

    /**
     * 获取英雄指定类型的六芒星数据
     *
     * @param type
     * @param hero
     * @return
     */
    private HeroHexagram getHexagramData(int type, Hero hero) {
        List<HeroHexagram> heroHexagrams = hero.getHexagram();
        HeroHexagram heroHexagram = null;
        for (HeroHexagram hexagram : heroHexagrams) {
            if (hexagram.getType() == type) {
                heroHexagram = hexagram;
                break;
            }
        }
        if (heroHexagram == null) {
            heroHexagram = new HeroHexagram();
            heroHexagram.setType(type);
            heroHexagram.setLevel(0);
            heroHexagrams.add(heroHexagram);
            heroService.updateHero(hero);
        }
        return heroHexagram;
    }
}
