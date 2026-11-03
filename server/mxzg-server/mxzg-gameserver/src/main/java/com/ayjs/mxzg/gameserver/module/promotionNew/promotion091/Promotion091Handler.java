package com.ayjs.mxzg.gameserver.module.promotionNew.promotion091;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.promotion091.Promotion091BoxLotteryRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion091.Promotion091Const;
import com.ayjs.mxzg.config.excel.entity.promotion091.CPromotion091BoxLotteryReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion091.domain.Promotion091;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion091.service.Promotion091Service;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion091GashaponLotteryRewardConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion091GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.OptionalInt;
import java.util.stream.Collectors;

/**
 * 万圣礼包
 */
@Controller
public class Promotion091Handler extends ProtocolHandler {
    @Autowired
    private Promotion091Service promotion091Service;
    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion091BoxLotteryRewardSysCache promotion091BoxLotteryRewardSysCache;
    @Autowired
    private Promotion091Const promotion091Const;

    @CMD(id = CmdCode._76211)
    public void giftInfo(PlayerContext playerContext, Promotion091GMsg.GReqSpringFestivalGetDataInfo msg) {
        Promotion091 promotionInfo = promotion091Service.getPromotionInfo(playerContext.getId());
        Promotion091GMsg.GResSpringFestivalGetDataInfo.Builder builder = Promotion091GMsg.GResSpringFestivalGetDataInfo.newBuilder();
        promotionInfo.getLotteryRecord().forEach((turns, record) -> {
            Promotion091GMsg.PSSpringFestivalTurnsRecord.Builder recordBuilder = Promotion091GMsg.PSSpringFestivalTurnsRecord.newBuilder();
            recordBuilder.setTurns(turns);
            record.forEach((place, idx) -> {
                ObjectGMsg.PSMapData.Builder placeBuilder = ObjectGMsg.PSMapData.newBuilder();
                placeBuilder.setKey(place).setValue(idx);
                recordBuilder.addPlaceRecord(placeBuilder);
            });
            builder.addLotteryRecord(recordBuilder);
        });
        builder.setCurrLotteryTurns(promotionInfo.getLotteryTurns());
        playerContext.write(CmdCode._76211, builder.build());
    }

    @CMD(id = CmdCode._76212)
    public void gashaponLottery(PlayerContext playerContext, Promotion091GMsg.GReqSpringFestivalGashaponLottery msg) {
        Asserts.isTrue(promotion091Service.isOpen(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                String.format("活动未开启"));

        Promotion091 promotionInfo = promotion091Service.getPromotionInfo(playerContext.getId());
        int currLotteryTurns = promotionInfo.getLotteryTurns();
        Map<Integer, Integer> turnsRecord = promotionInfo.getLotteryRecord().get(currLotteryTurns);
        if (turnsRecord == null) {
            turnsRecord = new HashMap<>();
            promotionInfo.getLotteryRecord().put(currLotteryTurns, turnsRecord);
            promotion091Service.updatePromotion(promotionInfo);
        }

        List<Promotion091GashaponLotteryRewardConfig> configList = promotion091Service.getByTurns(currLotteryTurns);

        Asserts.isTrue(!turnsRecord.containsKey(msg.getPlace()) && configList.size() >= msg.getPlace(),
                ErrorCode.PROMOTION_091_PLACE_ERROR.getValue(),
                String.format("位置{%s}错误", msg.getPlace()));

        Map<Integer, Integer> finalTurnsRecord = turnsRecord;
        configList = configList.stream().filter(config -> !finalTurnsRecord.containsValue(config.getIdx())).collect(Collectors.toList());

        ImmutableList<ImmutableThing> cost = promotion091Const.getGashaponCost();
        Asserts.isTrue(thingService.enough(playerContext.getId(), cost),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具{%s}数量不足", GsonUtils.toJson(cost)));

        Asserts.isTrue(!configList.isEmpty(), ErrorCode.PROMOTION_IS_CLOSE.getValue(), String.format("活动已关闭"));

        thingService.cost(playerContext.getId(), cost, GameEvent.PROMOTION_091_GASHAPON_LOTTERY_COST);

        Promotion091GashaponLotteryRewardConfig lotteryRewardConfig = DropUtil.randomDrop(configList);
        thingService.add(playerContext.getId(), lotteryRewardConfig.getRewardThings(), GameEvent.PROMOTION_091_GASHAPON_LOTTERY_REWARD, NoticeType.SLIENT);

        turnsRecord.put(msg.getPlace(), lotteryRewardConfig.getId());
        if (configList.size() == 1) {
            OptionalInt maxTurns = promotion091Service.getConfigList().stream().mapToInt(Promotion091GashaponLotteryRewardConfig::getTurns).max();
            if (maxTurns.isPresent() && promotionInfo.getLotteryTurns() < maxTurns.getAsInt()) {
                promotionInfo.setLotteryTurns(currLotteryTurns + 1);
            }
        }
        promotion091Service.updatePromotion(promotionInfo);

        Promotion091GMsg.GResSpringFestivalGashaponLottery.Builder builder = Promotion091GMsg.GResSpringFestivalGashaponLottery.newBuilder();
        builder.setLotteryTurns(currLotteryTurns);
        builder.setPlace(msg.getPlace());
        builder.setCurrLotteryTurns(promotionInfo.getLotteryTurns());
        builder.setIdx(lotteryRewardConfig.getIdx());
        playerContext.write(CmdCode._76212, builder.build());
    }

    @CMD(id = CmdCode._76213)
    public void boxLottery(PlayerContext playerContext, Promotion091GMsg.GReqSpringFestivalBoxLottery msg) {
        Asserts.isTrue(promotion091Service.isOpen(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                String.format("活动未开启"));

        ImmutableList<ImmutableThing> cost = promotion091Const.getBoxCost();
        Asserts.isTrue(thingService.enough(playerContext.getId(), cost),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具{%s}数量不足", GsonUtils.toJson(cost)));

        List<CPromotion091BoxLotteryReward> configList = promotion091BoxLotteryRewardSysCache.getAll();
        Asserts.isTrue(!configList.isEmpty(), ErrorCode.PROMOTION_IS_CLOSE.getValue(), String.format("活动已关闭"));

        thingService.cost(playerContext.getId(), cost, GameEvent.PROMOTION_091_BOX_LOTTERY_COST);
        CPromotion091BoxLotteryReward lotteryRewardConfig = DropUtil.randomDrop(configList);

        Promotion091 promotion = promotion091Service.getPromotionInfo(playerContext.getId());
        CPromotion091BoxLotteryReward hitConfig = promotion091BoxLotteryRewardSysCache.getHitConfig();
        if (hitConfig != null) {
            promotion.setLotteryCount(promotion.getLotteryCount() + 1);
            if (lotteryRewardConfig.getIdx() == hitConfig.getIdx() ||
                    hitConfig.getNeed_count() <= promotion.getLotteryCount()) {
                lotteryRewardConfig = hitConfig;
                promotion.setLotteryCount(0);
            }
        }
        promotion091Service.updatePromotion(promotion);

        thingService.add(playerContext.getId(), lotteryRewardConfig.getReward(), GameEvent.PROMOTION_091_BOX_LOTTERY_REWARD, NoticeType.SLIENT);

        Promotion091GMsg.GResSpringFestivalBoxLottery.Builder builder = Promotion091GMsg.GResSpringFestivalBoxLottery.newBuilder();
        builder.setIdx(lotteryRewardConfig.getIdx());
        playerContext.write(CmdCode._76213, builder.build());
    }
}
