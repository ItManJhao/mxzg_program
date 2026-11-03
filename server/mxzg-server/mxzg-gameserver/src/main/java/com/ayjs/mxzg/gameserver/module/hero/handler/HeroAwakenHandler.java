package com.ayjs.mxzg.gameserver.module.hero.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.excel.cache.HeroAwakenSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroAwaken;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroAwakenSelectEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.protocol.HeroAwakenGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2021/1/18
 **/
@Component
public class HeroAwakenHandler extends ProtocolHandler {

    @Autowired
    private HeroAwakenSysCache heroAwakenSysCache;
    @Autowired
    private HeroService heroService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EventBus eventBus;

    @CMD(id = CmdCode._4050)
    public void selectAttr(PlayerContext playerContext, HeroAwakenGMsg.GReqHeroAwakenSelect req) {

        Hero hero = heroService.getHero(playerContext.getId(), req.getHeroId());
        Asserts.isTrue(hero != null,
                ErrorCode.HERO_NOT_EXIST.getValue(),
                String.format("英雄{%s}不存在", req.getHeroId()));

        CHeroAwaken config = heroAwakenSysCache.getOrThrow(hero.getType());

        Asserts.isTrue(req.getBaseIndexCount() == config.getBase_count() && req.getSpecialIndexCount() == config.getSpecial_count(),
                ErrorCode.HERO_AWAKEN_ATTR_COUNT_ERROR.getValue(),
                String.format("基础{%s}，特殊{%s}", req.getBaseIndexCount(), req.getSpecialIndexCount()));

        Asserts.isTrue(req.getBaseIndexList().stream().allMatch(index -> index < config.getBase_attr().size()) &&
                        req.getSpecialIndexList().stream().allMatch(index -> index < config.getSpecial_attr().size()),
                ErrorCode.HERO_AWAKEN_ATTR_COUNT_ERROR.getValue(),
                String.format("觉醒请求数据{%s},{%s}", JsonUtil.toJson(req.getBaseIndexList()), JsonUtil.toJson(req.getSpecialIndexList())));

        if (hero.getAwaken().getBaseIndex().size() > 0) {
            thingService.cost(playerContext.getId(), config.getCost(), GameEvent.HERO_AWAKEN_COST);
        }

        hero.getAwaken().replace(req.getBaseIndexList(), req.getSpecialIndexList());
        heroService.updateHero(hero);

        HeroAwakenGMsg.GResHeroAwakenSelect.Builder builder = HeroAwakenGMsg.GResHeroAwakenSelect.newBuilder();
        HeroAwakenGMsg.PSHeroAwaken.Builder awakenBuilder = HeroAwakenGMsg.PSHeroAwaken.newBuilder();
        awakenBuilder.addAllBaseIndex(req.getBaseIndexList());
        awakenBuilder.addAllSpecialIndex(req.getSpecialIndexList());
        builder.setAwaken(awakenBuilder);
        builder.setHeroId(req.getHeroId());
        playerContext.write(CmdCode._4050, builder.build());

        eventBus.post(HeroAwakenSelectEvent.of(hero));

    }
}
