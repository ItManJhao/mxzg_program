package com.ayjs.mxzg.gameserver.module.promotionNew.handler;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion038Astrology;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion038AstrologyService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.Promotion038AstrologyCondition;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion038AstrologyConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion038GMsg;
import com.ayjs.mxzg.protocol.TaskObjGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;

@Controller
public class Promotion038AstrologyHandler extends ProtocolHandler {

    @Autowired
    private Promotion038AstrologyService promotion038AstrologyService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private HeroLineUpService heroLineUpService;


    @CMD(id = CmdCode._13100)
    public void astrologyTaskInfo(PlayerContext playerContext, Promotion038GMsg.GReqAstrologyTaskInfo msg) {

        Promotion038GMsg.GResAstrologyTaskInfo.Builder builder = Promotion038GMsg.GResAstrologyTaskInfo.newBuilder();

        PromotionControl control = promotionControlService.getControl(PromotionType.ZHAN_XING_ZHEN_REN_WU);


        Promotion038Astrology promotion038Astrology = promotion038AstrologyService.getPromotionInfo(playerContext.getId());

        for (Promotion038AstrologyConfig config : promotion038AstrologyService.selectConfigList()) {
            TaskObjGMsg.AstrologyTaskData.Builder data = TaskObjGMsg.AstrologyTaskData.newBuilder();
            data.setIdx(config.getIdx());
            if (promotion038Astrology.getRewardList().contains(config.getIdx())) {
                data.setStatus(1);
            } else {
                data.setStatus(0);
            }
            builder.addList(data.build());
        }

        playerContext.write(CmdCode._13100, builder.build());
    }

    @CMD(id = CmdCode._13101)
    public void astrologyTaskSubmit(PlayerContext playerContext, Promotion038GMsg.GReqAstrologyTaskSubmit msg) {
        Promotion038GMsg.GResAstrologyTaskSubmit.Builder builder = Promotion038GMsg.GResAstrologyTaskSubmit.newBuilder();
        Role role = roleService.getOrThrow(playerContext.getId());

        if (!promotionControlService.isPromotionRunning(PromotionType.ZHAN_XING_ZHEN_REN_WU)) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_TIME.getValue(), "PromotionType.ZHAN_XING_ZHEN_REN_WU");
        }

        Promotion038Astrology promotion038Astrology = promotion038AstrologyService.getPromotionInfo(role.getId());
        if (promotion038Astrology.getRewardList().contains(msg.getIdx())) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_REWARD_ALREADY_GET.getValue(), "PromotionType.ZHAN_XING_ZHEN_REN_WU");
        }

        Promotion038AstrologyConfig config = promotion038AstrologyService.selectConfigOne(msg.getIdx());
        if (Objects.isNull(config)) {
            throw new ErrorCodeException(ErrorCode.CONFIG_NOT_EXISTS.getValue(), "PromotionType.ZHAN_XING_ZHEN_REN_WU，活动配置不存在");
        }

        List<Hero> heroList = new ArrayList<>();
        //按位置进行判断
        Map<Integer, List<Hero>> placeHeroMap = new HashMap<>();
        for (ObjectGMsg.PSBackpackData placeData : msg.getHerosList()) {
            //阵上的英雄不能用于占星阵
            Hero hero = heroService.getUnlockInLineUpHero(role.getId(), placeData.getId());

            Asserts.isTrue(!Objects.isNull(hero), ErrorCode.PROMOTION_ASTROLOGY_HERO_LINEUP.getValue(),
                    "该英雄不能用于兑换。hid:" + placeData.getId());

            heroList.add(hero);
            List<Hero> list = placeHeroMap.get(placeData.getType());
            if (list == null) {
                list = new ArrayList<>();
                //浩子说把位置信息设置在type字段上
                placeHeroMap.put(placeData.getType(), list);
            }
            list.add(hero);
        }

        List<Long> heroIds = heroList.stream().map(Hero::getId).collect(Collectors.toList());;
        Asserts.isTrue(!heroLineUpService.isHeroDeletes(playerContext.getId(), heroIds), ErrorCode.HERO_CANT_DELETE_LINEUP_ALL.getValue(),
                "不能删除指定阵型上的所有英雄");

        List<Promotion038AstrologyCondition> conditionList =
                JsonUtil.getList(config.getNeed_hero(), Promotion038AstrologyCondition.class);
        for (Promotion038AstrologyCondition condition : conditionList) {
            List<Hero> list = placeHeroMap.get(condition.getPlace());
            if (list == null) {
                //不符合兑换要求
                return;
            }
            for (Hero hero : list) {
                CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
                if ((condition.getType() == 0 || condition.getType() == hero.getType()) &&
                        (condition.getOccupation() == 0 || condition.getOccupation() == cHeroType.getOccupation()) &&
                        (condition.getElem() == 0 || condition.getElem() == cHeroType.getElem()) &&
                        (condition.getStar() == 0 || condition.getStar() == hero.getStar())) {
                    condition.setNum(condition.getNum() - 1);
                }
            }
            if (condition.getNum() > 0) {
                //素材不足
                return;
            }
        }

        List<ImmutableThing> costList = ImmutableThingUtil.fromJson(config.getNeed_item());
        if (!costList.isEmpty()) {
            thingService.cost(role.getId(), costList, GameEvent.ASTROLOGY_TASK_SUBMIT);
        }

        //删除英雄
        heroService.deleteHeros(role.getId(), heroList, GameEvent.ASTROLOGY_TASK_SUBMIT);

        //记录奖励已经兑换
        Set<Integer> rewardList = promotion038Astrology.getRewardList();
        rewardList.add(msg.getIdx());
        promotion038Astrology.setRewardList(rewardList);
        promotion038AstrologyService.updatePromotion(promotion038Astrology);

        //添加道具
        thingService.add(role.getId(), ImmutableThingUtil.fromJson(config.getReward()), GameEvent.ASTROLOGY_TASK_SUBMIT);
        builder.setIdx(msg.getIdx());
        builder.setIsOver(1);
        playerContext.write(CmdCode._13101, builder.build());
    }
}
