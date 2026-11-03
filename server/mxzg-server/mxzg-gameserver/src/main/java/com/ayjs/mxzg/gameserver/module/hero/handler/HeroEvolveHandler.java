package com.ayjs.mxzg.gameserver.module.hero.handler;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.HeroEvolveLevelSysCache;
import com.ayjs.mxzg.config.excel.constant.HeroEvolveConst;
import com.ayjs.mxzg.config.excel.entity.CHeroEvolveLevel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroEvolveEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroEvolveService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroConsume;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroEvolve;
import com.ayjs.mxzg.gameserver.module.hero.util.HeroConsumeUtil;
import com.ayjs.mxzg.gameserver.module.tweakCube.service.TweakCubeService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.HeroGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/7/15
 **/
@Component
public class HeroEvolveHandler extends ProtocolHandler {

    @Autowired
    private HeroService heroService;
    @Autowired
    private HeroEvolveLevelSysCache heroEvolveLevelSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private HeroEvolveConst heroEvolveConst;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private TweakCubeService tweakCubeService;
    @Autowired
    private HeroEvolveService heroEvolveService;

    @CMD(id = CmdCode._4070)
    public void evolve(PlayerContext playerContext, HeroGMsg.GReqEvolve req) {
        Hero mainHero = heroService.getHero(playerContext.getId(), req.getHeroId());
        Asserts.isTrue(Objects.nonNull(mainHero), ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄{%s}不存在", req.getHeroId()));
        HeroEvolve heroEvolve = mainHero.getEvolve();
        Asserts.isTrue(heroEvolve.getType() == req.getType() || heroEvolve.getType() == 0,
                ErrorCode.HERO_HAD_EVOLVE.getValue(), String.format("英雄{%s}已经进化{%s}-{%s}", req.getHeroId(), heroEvolve.getType(), req.getType()));
        CHeroEvolveLevel config = heroEvolveLevelSysCache.getBy(mainHero.getType(), req.getType(), heroEvolve.getLevel() + 1);
        Asserts.isTrue(Objects.nonNull(config), ErrorCode.CONFIG_NOT_EXIST.getValue(), String.format("英雄{%s}进化到最高级{%s}-{%s}",
                req.getHeroId(), req.getType(), heroEvolve.getLevel() + 1));

        Asserts.isTrue(mainHero.getStar() >= heroEvolveConst.getHeroEvolveNeedStar(), ErrorCode.CONFIG_NOT_EXIST.getValue(),
                String.format("英雄{%s}星级不够{%s}", mainHero.getType(), mainHero.getStar()));

        Asserts.isTrue(thingService.enough(playerContext.getId(), config.getConsume_item()), ErrorCode.ITEM_NUM_LOW.getValue(), "道具数量不足");

        List<HeroGMsg.PSHeroConsume> psHeroConsumes = req.getConsumeList();
        List<HeroConsume> needHeroList = JsonUtil.getList(config.getConsume_hero(), HeroConsume.class);

        Asserts.isTrue(psHeroConsumes.size() == needHeroList.size(), ErrorCode.HERO_NUM_LOW.getValue(), "英雄数量不足");

        Map<Integer, List<Hero>> consumeMap = Maps.newHashMap();
        psHeroConsumes.forEach(psHeroConsume -> {
            psHeroConsume.getHeroIdList().forEach(heroId -> {
                Asserts.isTrue(req.getHeroId() != heroId,
                        ErrorCode.HERO_CONSUME_NOT_MATCH.getValue(), "英雄" + mainHero.getId() + "正在进化");
                Hero consumeHero = heroService.getHero(playerContext.getId(), heroId);
                Asserts.isTrue(Objects.nonNull(consumeHero), ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄{%s}不存在", heroId));
                Asserts.isTrue(!heroLineUpService.isHeroLockInLineUp(playerContext.getId(), heroId),
                        ErrorCode.HERO_CANT_DELETE_LINEUP.getValue(), "英雄" + heroId + "还在阵上，不能删除");

                Asserts.isTrue(!tweakCubeService.isInTrench(playerContext.getId(), heroId),
                        ErrorCode.TWEAK_CUBE_TRENCH_HERO_CANT_OPERATOR.getValue(),
                        String.format("槽位上的英雄{%s}不允许该操作", heroId));

                consumeMap.computeIfAbsent(psHeroConsume.getIndex(), key -> Lists.newArrayList()).add(consumeHero);
            });
        });

        List<Hero> consumeHeroes = new ArrayList<>();
        for (int i = 0; i < needHeroList.size(); i++) {
            HeroConsume heroConsume = needHeroList.get(i);
            List<Hero> heroes = consumeMap.get(i);
            Asserts.isTrue(HeroConsumeUtil.matchConsume(heroConsume, heroes, mainHero), ErrorCode.HERO_NOT_EXIST.getValue(),
                    String.format("英雄消耗{%s}不存在", GJsonUtils.toJson(heroConsume)));
            if (!CollectionUtil.isEmpty(heroes)) {
                consumeHeroes.addAll(heroes);
            }
        }

        List<Long> heroIds = consumeHeroes.stream().map(Hero::getId).collect(Collectors.toList());
        Asserts.isTrue(!heroLineUpService.isHeroDeletes(playerContext.getId(), heroIds),
                ErrorCode.HERO_CANT_DELETE_LINEUP_ALL.getValue(), "不能删除指定阵型上的所有英雄");

        QueryHeroCommand beforeEvolve = QueryHeroCommand.createOf(mainHero);
        commandBus.invoke(beforeEvolve);
        beforeEvolve.getHeroDo().initAttribute();

        thingService.cost(playerContext.getId(), config.getConsume_item(), GameEvent.HERO_EVOLVE);

        heroService.deleteHeros(playerContext.getId(), consumeHeroes, GameEvent.HERO_EVOLVE);

        heroEvolve.setType(req.getType());
        heroEvolve.setLevel(heroEvolve.getLevel() + 1);
        consumeHeroes.forEach(hero_ -> heroEvolve.getHadConsume().add(HeroConsume.of(hero_)));

        heroService.updateHero(mainHero);

        QueryHeroCommand afterEvolve = QueryHeroCommand.createOf(mainHero);
        commandBus.invoke(afterEvolve);
        afterEvolve.getHeroDo().getAttributeInfo().initAttribute();

        HeroGMsg.GResEvolve.Builder builder = HeroGMsg.GResEvolve.newBuilder();
        HeroGMsg.PSHeroEvolve.Builder evolveBuilder = HeroGMsg.PSHeroEvolve.newBuilder();
        evolveBuilder.setType(heroEvolve.getType());
        evolveBuilder.setLevel(heroEvolve.getLevel());
        builder.setEvolve(evolveBuilder);
        builder.setHeroId(mainHero.getId());
        config.getAttr_show().keySet().forEach(attributeType -> {
            AttributeType showType = attributeType.getShowType();
            HeroGMsg.PSAttrUpdate.Builder attrUpdate = HeroGMsg.PSAttrUpdate.newBuilder();
            attrUpdate.setAttrType(showType.getValue());
            attrUpdate.setOldValue(beforeEvolve.getHeroDo().getAttribute(showType));
            attrUpdate.setNewValue(afterEvolve.getHeroDo().getAttribute(showType));
            builder.addUpdate(attrUpdate);
        });

        playerContext.write(CmdCode._4070, builder.build());

        eventBus.post(HeroEvolveEvent.of(mainHero));

    }

    @CMD(id = CmdCode._4071)
    public void evolveBack(PlayerContext playerContext, HeroGMsg.GReqEvolveBack req) {
        Hero hero = heroService.getHero(playerContext.getId(), req.getHeroId());
        Asserts.isTrue(hero != null,
                ErrorCode.HERO_NOT_EXIST.getValue(),
                String.format("英雄{%s}不存在", req.getHeroId()));
        Asserts.isTrue(hero.getEvolve().getType() > 0,
                ErrorCode.HERO_NOT_EVOLVE.getValue(),
                String.format("英雄{%s}未进化", req.getHeroId(), hero.getEvolve().getType()));

        Asserts.isTrue(thingService.enough(playerContext.getId(), heroEvolveConst.getEvolveBackCost()),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具数量不足{%s}", GsonUtils.toJson(heroEvolveConst.getEvolveBackCost())));

        thingService.cost(playerContext.getId(), heroEvolveConst.getEvolveBackCost(), GameEvent.HERO_EVOLVE_BACK);

        Rewards reward = heroEvolveService.evolveBack(hero, NoticeType.SLIENT);
        HeroGMsg.GResEvolveBack.Builder builder = HeroGMsg.GResEvolveBack.newBuilder();
        builder.setHeroId(hero.getId());
        builder.setEvolve(PbUtil.builderEvolve(hero));
        builder.addAllReward(heroEvolveService.builderRewardList(reward));
        playerContext.write(CmdCode._4071, builder.build());
    }

}
