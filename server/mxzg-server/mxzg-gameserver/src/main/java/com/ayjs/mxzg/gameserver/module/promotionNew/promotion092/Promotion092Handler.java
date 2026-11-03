package com.ayjs.mxzg.gameserver.module.promotionNew.promotion092;

import cn.hutool.core.util.RandomUtil;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.promotion092.Promotion092BuyFlowerSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion092.Promotion092CountRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion092.Promotion092DeliverRandomRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion092.CPromotion092BuyFlower;
import com.ayjs.mxzg.config.excel.entity.promotion092.CPromotion092CountReward;
import com.ayjs.mxzg.config.excel.entity.promotion092.CPromotion092DeliverRandomReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion092.domain.Promotion092;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion092.service.DeliverCountRankService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion092.service.HeroScoreRankService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion092.service.Promotion092Service;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092DeliverReqMessage;
import com.ayjs.mxzg.message.module.promotion092.struct.DeliverData;
import com.ayjs.mxzg.protocol.Promotion092GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 女神献花
 */
@Controller
public class Promotion092Handler extends ProtocolHandler {
    @Autowired
    private Promotion092Service promotion092Service;
    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion092DeliverRandomRewardSysCache promotion092DeliverRandomRewardSysCache;
    @Autowired
    private DeliverCountRankService deliverCountRankService;
    @Autowired
    private HeroScoreRankService heroScoreRankService;
    @Autowired
    private Promotion092CountRewardSysCache promotion092CountRewardSysCache;
    @Autowired
    private Promotion092BuyFlowerSysCache promotion092BuyFlowerSysCache;
    @Autowired
    private MessageDispatcher messageDispatcher;


    @CMD(id = CmdCode._76231)
    public void getData(PlayerContext playerContext, Promotion092GMsg.GReqDeliverFlowerGetData req) {
        Promotion092 promotion = promotion092Service.getPromotionInfo(playerContext.getId());
        Promotion092GMsg.GResDeliverFlowerGetData.Builder builder = Promotion092GMsg.GResDeliverFlowerGetData.newBuilder();
        promotion.getDeliverData().forEach(heroScoreRankData -> {
            builder.addHeroScores(PbUtil.builderMap(heroScoreRankData.getHeroType(), heroScoreRankData.getScore()));
        });
        builder.setBuyCount(promotion.getBuyCount());
        builder.setDeliverCount(promotion.getCount());
        builder.addAllCountRewardIdx(promotion.getCountRewardRecord());
        playerContext.write(CmdCode._76231, builder.build());
    }

    @CMD(id = CmdCode._76232)
    public void deliverFlower(PlayerContext playerContext, Promotion092GMsg.GReqDeliverFlower req) {
        Asserts.isTrue(promotion092Service.isOpen(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                "活动未开启");

        Asserts.isTrue(req.getCount() > 0,
                ErrorCode.SYSTEM_ERROR.getValue(),
                String.format("数量错误：{%s}", req.getCount()));

        Promotion092 promotion = promotion092Service.getPromotionInfo(playerContext.getId());

        DeliverData deliverData = promotion.getDeliverData().stream().filter(heroScoreRankData ->
                heroScoreRankData.getHeroType() == req.getHeroType()).findFirst().orElse(null);

        Asserts.isTrue(deliverData != null,
                ErrorCode.HERO_NOT_EXIST.getValue(),
                String.format("不存在该英雄：{%s}", req.getHeroType()));

        thingService.cost(playerContext.getId(), ImmutableThingUtil.multiplyThing(promotion092Service.getConfig().getDeliverCostThings(), req.getCount()),
                GameEvent.PROMOTION_092_DELIVER_COST);

        promotion.setCount(promotion.getCount() + req.getCount());
        promotion.setRankTime(LocalDateTime.now());
        int addScore = promotion092Service.getConfig().getScore() * req.getCount();
        deliverData.setScore(addScore + deliverData.getScore());
        deliverData.setRankTime(LocalDateTime.now());
        promotion092Service.updatePromotion(promotion);

        List<CPromotion092DeliverRandomReward> randomConfigs = RandomUtil.randomEles(promotion092DeliverRandomRewardSysCache.getAll(), req.getCount());
        List<ImmutableThing> rewards = randomConfigs.stream().map(CPromotion092DeliverRandomReward::getReward).flatMap(Collection::stream).collect(Collectors.toList());
        rewards = ImmutableThingUtil.mergeThing(rewards);

        thingService.add(playerContext.getId(), rewards, GameEvent.PROMOTION_092_DELIVER_REWARD);

        messageDispatcher.dispatch(Promotion092DeliverReqMessage.of(playerContext.getId(),
                addScore, deliverData.getHeroType(), promotion.getCount(), promotion.getRankTime()));

        Promotion092GMsg.GResDeliverFlower.Builder builder = Promotion092GMsg.GResDeliverFlower.newBuilder();
        builder.setHeroScore(PbUtil.builderMap(deliverData.getHeroType(), deliverData.getScore()));
        builder.setDeliverCount(promotion.getCount());
        playerContext.write(CmdCode._76232, builder.build());

//        eventBus.post(DeliverFlowerEvent.of(playerContext.getId(), deliverData));
    }

    @CMD(id = CmdCode._76233)
    public void selectHero(PlayerContext playerContext, Promotion092GMsg.GReqDeliverFlowerSelectHero req) {
        Asserts.isTrue(promotion092Service.isOpen(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                "活动未开启");
        Promotion092 promotion = promotion092Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(promotion.getDeliverData().size() == 0,
                ErrorCode.PROMOTION_092_HAD_SELECT_HERO.getValue(),
                "已经选择了英雄");
        Asserts.isTrue(req.getHeroTypeCount() == 3,
                ErrorCode.SYSTEM_ERROR.getValue(),
                String.format("选择英雄错误：{%s},数量不对", GsonUtils.toJson(req.getHeroTypeList())));

        Asserts.isTrue(promotion092Service.getConfig().getSelectHeroes().containsAll(req.getHeroTypeList()),
                ErrorCode.SYSTEM_ERROR.getValue(),
                String.format("选择英雄错误：{%s}，不能选择该英雄", GsonUtils.toJson(req.getHeroTypeList())));

//        List<Hero> heroes = heroService.getHeros(playerContext.getId());
//        Asserts.isTrue(heroes.stream().mapToInt(Hero::getType).distinct().boxed().collect(Collectors.toSet()).containsAll(req.getHeroTypeList()),
//                ErrorCode.SYSTEM_ERROR.getValue(),
//                String.format("选择英雄错误：{%s}，未拥有该英雄", GsonUtils.toJson(req.getHeroTypeList())));
        int index = 1;
        for (Integer heroType : req.getHeroTypeList()) {
            DeliverData data = new DeliverData();
            data.setHeroType(heroType);
            data.setRankTime(LocalDateTime.now());
            data.setIndex(index++);
            promotion.getDeliverData().add(data);
        }
        promotion092Service.updatePromotion(promotion);

        Promotion092GMsg.GResDeliverFlowerSelectHero.Builder builder = Promotion092GMsg.GResDeliverFlowerSelectHero.newBuilder();
        promotion.getDeliverData().forEach(heroScoreRankData -> {
            builder.addHeroScores(PbUtil.builderMap(heroScoreRankData.getHeroType(), heroScoreRankData.getScore()));
        });
        playerContext.write(CmdCode._76233, builder.build());

    }

    @CMD(id = CmdCode._76234)
    public void countRank(PlayerContext playerContext, Promotion092GMsg.GReqDeliverCountRank req) {
        List<Promotion092GMsg.PSDeliverCountRank> rankList = deliverCountRankService.showRanks(20);
        Promotion092GMsg.PSDeliverCountRank self = deliverCountRankService.selfRank(playerContext.getId());
        Promotion092GMsg.GResDeliverCountRank.Builder builder = Promotion092GMsg.GResDeliverCountRank.newBuilder();
        builder.addAllList(rankList);
        builder.setSelf(self);
        playerContext.write(CmdCode._76234, builder.build());
    }

    @CMD(id = CmdCode._76235)
    public void heroScoreRank(PlayerContext playerContext, Promotion092GMsg.GReqHeroScoreRank req) {
        List<Promotion092GMsg.PSHeroScoreRank> rankList = heroScoreRankService.showRanks(20);
        Promotion092GMsg.GResHeroScoreRank.Builder builder = Promotion092GMsg.GResHeroScoreRank.newBuilder();
        builder.addAllList(rankList);
        playerContext.write(CmdCode._76235, builder.build());
    }

    @CMD(id = CmdCode._76236)
    public void buyFlower(PlayerContext playerContext, Promotion092GMsg.GReqBuyFlower req) {
        Asserts.isTrue(promotion092Service.isOpen(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                "活动未开启");

        Asserts.isTrue(req.getCount() > 0,
                ErrorCode.SYSTEM_ERROR.getValue(),
                String.format("数量错误：{%s}", req.getCount()));

        Promotion092 promotion = promotion092Service.getPromotionInfo(playerContext.getId());

        Asserts.isTrue(promotion.getCount() >= promotion092Service.getConfig().getNeed_count(),
                ErrorCode.PROMOTION_092_DELIVER_COUNT_LOW.getValue(),
                String.format("献花次数：{%s}", promotion.getCount()));

        int totalBuyCount = promotion.getBuyCount() + req.getCount();
        Map<CPromotion092BuyFlower, Integer> config = promotion092BuyFlowerSysCache.getByCount(promotion.getBuyCount(), totalBuyCount);

        List<ImmutableThing> totalCost = new ArrayList<>();
        List<ImmutableThing> totalReward = new ArrayList<>();
        config.forEach((configTemp, countTemp) -> {
            totalCost.addAll(ImmutableThingUtil.multiplyThing(configTemp.getCost(), countTemp));
            totalReward.addAll(ImmutableThingUtil.multiplyThing(configTemp.getReward(), countTemp));
        });
        thingService.cost(playerContext.getId(), totalCost, GameEvent.PROMOTION_092_BUY_FLOWER_COST);

        promotion.setBuyCount(promotion.getBuyCount() + req.getCount());
        promotion092Service.updatePromotion(promotion);

        thingService.add(playerContext.getId(), totalReward, GameEvent.PROMOTION_092_BUY_FLOWER_REWARD);
        Promotion092GMsg.GResBuyFlower.Builder builder = Promotion092GMsg.GResBuyFlower.newBuilder();
        builder.setBuyCount(promotion.getBuyCount());
        playerContext.write(CmdCode._76236, builder.build());
    }

    @CMD(id = CmdCode._76237)
    public void countReward(PlayerContext playerContext, Promotion092GMsg.GReqDeliverFlowerCountReward req) {
        Promotion092 promotion = promotion092Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(!promotion.getCountRewardRecord().contains(req.getIdx()),
                ErrorCode.SYSTEM_ERROR.getValue(),
                String.format("奖励已经领取：{%s},{%s}", GsonUtils.toJson(promotion.getCountRewardRecord()), req.getIdx()));


        CPromotion092CountReward config = promotion092CountRewardSysCache.getOrThrow(req.getIdx());
        Asserts.isTrue(promotion.getCount() >= config.getCount(),
                ErrorCode.SYSTEM_ERROR.getValue(),
                String.format("次数不足：{%s},{%s}", promotion.getCount(), req.getIdx()));

        promotion.getCountRewardRecord().add(config.getIdx());
        promotion092Service.updatePromotion(promotion);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_092_DELIVER_COUNT_REWARD);
        Promotion092GMsg.GResDeliverFlowerCountReward.Builder builder = Promotion092GMsg.GResDeliverFlowerCountReward.newBuilder();
        builder.setIdx(req.getIdx());
        playerContext.write(CmdCode._76237, builder.buildPartial());
    }
}
