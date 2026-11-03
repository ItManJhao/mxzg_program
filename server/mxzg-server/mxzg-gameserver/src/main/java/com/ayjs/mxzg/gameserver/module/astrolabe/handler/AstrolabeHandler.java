package com.ayjs.mxzg.gameserver.module.astrolabe.handler;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.astrolabe.AstrolabeConst;
import com.ayjs.mxzg.config.excel.cache.astrolabe.AstrolabeElementSysCache;
import com.ayjs.mxzg.config.excel.cache.astrolabe.AstrolabeSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.excel.entity.astrolabe.CAstrolabe;
import com.ayjs.mxzg.config.excel.entity.astrolabe.CAstrolabeElement;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.astrolabe.domain.Astrolabe;
import com.ayjs.mxzg.gameserver.module.astrolabe.event.AstrolabeChangeEvent;
import com.ayjs.mxzg.gameserver.module.astrolabe.service.AstrolabeService;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.protocol.AstrolabeGMsg;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/4/27
 **/
@Component
public class AstrolabeHandler extends ProtocolHandler {

    @Autowired
    private AstrolabeService astrolabeService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private AstrolabeConst astrolabeConst;
    @Autowired
    private ThingService thingService;
    @Autowired
    private AstrolabeSysCache astrolabeSysCache;
    @Autowired
    private AstrolabeElementSysCache astrolabeElementSysCache;
    @Autowired
    private EventBus eventBus;

    @CMD(id = CmdCode._68001)
    public void getData(PlayerContext playerContext, AstrolabeGMsg.GReqAstrolabeData req) {
        Astrolabe astrolabe = astrolabeService.load(playerContext.getId());
        AstrolabeGMsg.GResAstrolabeData.Builder builder = AstrolabeGMsg.GResAstrolabeData.newBuilder();
        builder.setMaxStar(astrolabe.getMaxStar());
        builder.addAllActiveElem(astrolabe.getActiveElem());
        astrolabe.getLightStar().forEach((key, value) -> {
            ObjectGMsg.PSMapData.Builder mapBuilder = ObjectGMsg.PSMapData.newBuilder();
            mapBuilder.setKey(key);
            mapBuilder.setValue(value);
            builder.addActive(mapBuilder);
        });
        builder.setActiveAstrolabe(astrolabe.isActive());
        playerContext.write(CmdCode._68001, builder.build());
    }

    /***
     * 激活元素
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._68002)
    public void activeElem(PlayerContext playerContext, AstrolabeGMsg.GReqAstrolabeActiveElem req) {
        Astrolabe astrolabe = astrolabeService.load(playerContext.getId());

        HeroLineUp mainLineUp = heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.MAIN);
        Map<Integer, Integer> elemCount = new HashMap<>();

        Asserts.isTrue(thingService.enough(playerContext.getId(), astrolabeConst.getActiveElementCost()),
                ErrorCode.ITEM_NUM_LOW.getValue(), "道具数量不足");

        List<Integer> allElements = astrolabeElementSysCache.getAll().stream().mapToInt(CAstrolabeElement::getIdx)
                .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);
        Asserts.isTrue(allElements.size() > astrolabe.getActiveElem().size(), ErrorCode.ASTROLABE_ELEM_HAD_ACTIVE.getValue()
                , String.format("所有元素已激活,元素数量{%s}-{%s}", allElements.size(), astrolabe.getActiveElem().size()));

        List<Integer> canActiveElements = allElements.stream().
                filter(elem -> !astrolabe.getActiveElem().contains(elem)).collect(Collectors.toList());

        mainLineUp.getFormationMap().values().forEach(heroPosition -> {
            CHeroType config = heroTypeSysCache.getById(heroPosition.getHeroType());
            elemCount.put(config.getElem(), elemCount.getOrDefault(config.getElem(), 0) + 1);
        });
        //先随机，在按上阵元素多的阵容取值
        Collections.shuffle(canActiveElements);
        canActiveElements.sort(new Comparator<Integer>() {
            @Override
            public int compare(Integer o1, Integer o2) {
                return elemCount.getOrDefault(o2, 0) - elemCount.getOrDefault(o1, 0);
            }
        });

        thingService.cost(playerContext.getId(), astrolabeConst.getActiveElementCost(), GameEvent.ASTROLABE_ACTIVE_ELEMENT_COST);

        Integer elem = canActiveElements.get(0);
        astrolabe.getActiveElem().add(elem);
        astrolabeService.update(astrolabe);

        AstrolabeGMsg.GResAstrolabeActiveElem.Builder builder = AstrolabeGMsg.GResAstrolabeActiveElem.newBuilder();
        builder.setActiveAstrolabe(astrolabe.isActive());
        builder.setActiveElem(elem);
        playerContext.write(CmdCode._68002, builder.build());

        eventBus.post(AstrolabeChangeEvent.of(playerContext.getId(), GameEvent.ASTROLABE_ACTIVE_LIGHT));
    }

    @CMD(id = CmdCode._68003)
    public void light(PlayerContext playerContext, AstrolabeGMsg.GReqAstrolabeLight req) {
        Astrolabe astrolabe = astrolabeService.load(playerContext.getId());

        CAstrolabe config = astrolabeSysCache.getById(req.getIdx());

        Asserts.isTrue(astrolabe.isActive(), ErrorCode.ASTROLABE_ELEM_HAD_ACTIVE.getValue()
                , String.format("没有激活星盘{%s}", astrolabe.isActive()));

        Asserts.isTrue((req.getSkillId() == 0 && CollectionUtil.isEmpty(config.getSkills()))
                        || config.getSkills().contains(req.getSkillId()),
                ErrorCode.ASTROLABE_SKILL_ERROR.getValue(),
                String.format("点亮{%s}，技能id：{%s}错误", req.getIdx(), req.getSkillId()));

        List<Integer> needActiveIds = astrolabeSysCache.getAll().stream().filter(config_ -> config_.getStar() < config.getStar())
                .mapToInt(CAstrolabe::getIdx).collect(ArrayList::new, ArrayList::add, ArrayList::addAll);

        Asserts.isTrue(astrolabe.getLightStar().keySet().containsAll(needActiveIds),
                ErrorCode.ASTROLABE_LOW_STAR_NOT_ACTIVE.getValue(),
                String.format("点亮{%s}，已激活列表{%s}", req.getIdx(), GsonUtils.toJson(astrolabe.getLightStar().keySet())));

        Asserts.isTrue(!astrolabe.getLightStar().containsKey(req.getIdx()), ErrorCode.ASTROLABE_STAR_HAD_LIGHT.getValue(),
                String.format("该星级{%s}已经点亮{%s}", req.getIdx(), JsonUtil.toJson(astrolabe.getLightStar().keySet())));

        Asserts.isTrue(astrolabe.getMaxStar() >= config.getStar(), ErrorCode.ASTROLABE_MAX_STAR_LOW.getValue(),
                String.format("该星级数量{%s}不足{%s}", astrolabe.getMaxStar(), config.getStar()));

        if (CollectionUtil.isNotEmpty(config.getCost())) {
            Asserts.isTrue(thingService.enough(playerContext.getId(), config.getCost()),
                    ErrorCode.ITEM_NUM_LOW.getValue(), "道具数量不足");
            thingService.cost(playerContext.getId(), config.getCost(), GameEvent.ASTROLABE_ACTIVE_LIGHT);
        }

        astrolabe.getLightStar().put(req.getIdx(), req.getSkillId());
        astrolabeService.update(astrolabe);

        AstrolabeGMsg.GResAstrolabeLight.Builder builder = AstrolabeGMsg.GResAstrolabeLight.newBuilder();
        astrolabe.getLightStar().forEach((key, value) -> {
            ObjectGMsg.PSMapData.Builder mapBuilder = ObjectGMsg.PSMapData.newBuilder();
            mapBuilder.setKey(key);
            mapBuilder.setValue(value);
            builder.addActive(mapBuilder);
        });
        playerContext.write(CmdCode._68003, builder.build());

        eventBus.post(AstrolabeChangeEvent.of(playerContext.getId(), GameEvent.ASTROLABE_ACTIVE_LIGHT));
    }

    @CMD(id = CmdCode._68004)
    public void reset(PlayerContext playerContext, AstrolabeGMsg.GReqAstrolabeReset req) {
        Astrolabe astrolabe = astrolabeService.load(playerContext.getId());

        Asserts.isTrue(thingService.enough(playerContext.getId(), astrolabeConst.getAstrolabeResetCost()),
                ErrorCode.ITEM_NUM_LOW.getValue(), "道具数量不足");

        thingService.cost(playerContext.getId(), astrolabeConst.getAstrolabeResetCost(), GameEvent.ASTROLABE_ACTIVE_ELEMENT_COST);

        List<ImmutableThing> reward = new ArrayList<>();

        List<ImmutableThing> finalReward = reward;
        astrolabe.getLightStar().keySet().forEach(idx -> finalReward.addAll(astrolabeSysCache.getById(idx).getCost()));
        reward = ImmutableThingUtil.mergeThing(reward);

        astrolabe.getLightStar().clear();
        astrolabeService.update(astrolabe);
        if (ImmutableThingUtil.getAllItemNums(reward) > 0) {
            thingService.add(playerContext.getId(), reward, GameEvent.ASTROLABE_RESET_BACK);
        }

        playerContext.write(CmdCode._68004, AstrolabeGMsg.GResAstrolabeReset.getDefaultInstance());

        eventBus.post(AstrolabeChangeEvent.of(playerContext.getId(), GameEvent.ASTROLABE_ACTIVE_ELEMENT_COST));

    }

    @CMD(id = CmdCode._68006)
    public void unlock(PlayerContext playerContext, AstrolabeGMsg.GReqAstrolabeUnlockElem req) {
        Astrolabe astrolabe = astrolabeService.load(playerContext.getId());

        Asserts.isTrue(!astrolabe.isActive(), ErrorCode.ASTROLABE_ELEM_HAD_ACTIVE.getValue()
                , String.format("星盘已激活{%s}", astrolabe.isActive()));

        Asserts.isTrue(astrolabe.getActiveElem().size() == astrolabeElementSysCache.getAll().size(),
                ErrorCode.ASTROLABE_ELEM_HAD_ACTIVE.getValue(), String.format("元素激活数量不足，当前{%s},元素数量{%s}",
                        astrolabe.getActiveElem().size(), astrolabeElementSysCache.getAll().size()));

        astrolabe.setActive(true);
        astrolabeService.update(astrolabe);

        AstrolabeGMsg.GResAstrolabeUnlockElem.Builder builder = AstrolabeGMsg.GResAstrolabeUnlockElem.newBuilder();
        builder.setActiveAstrolabe(true);
        playerContext.write(CmdCode._68006, builder.build());

    }

}
