package com.ayjs.mxzg.gameserver.module.promotionNew.promotion087;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.promotion087.Promotion087LotteryTypeSysCache;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion087.domain.Promotion087;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion087.service.Promotion087Service;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion087LotteryRewardConfig;
import com.ayjs.mxzg.protocol.Promotion087GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 万圣礼包
 */
@Controller
public class Promotion087Handler extends ProtocolHandler {
    @Autowired
    private Promotion087Service promotion087Service;
    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion087LotteryTypeSysCache promotion087LotteryTypeSysCache;

    @CMD(id = CmdCode._76121)
    public void giftInfo(PlayerContext playerContext, Promotion087GMsg.GReqChristmasLotteryGetDataInfo msg) {
        Promotion087 promotionInfo = promotion087Service.getPromotionInfo(playerContext.getId());
        Promotion087GMsg.GResChristmasLotteryGetDataInfo.Builder builder = Promotion087GMsg.GResChristmasLotteryGetDataInfo.newBuilder();
        builder.addAllLotteryRecord(promotionInfo.getLotteryRecord()).setBookmark(promotionInfo.getLotteryType());
        playerContext.write(CmdCode._76121, builder.build());
    }

    @CMD(id = CmdCode._76122)
    public void lottery(PlayerContext playerContext, Promotion087GMsg.GReqChristmasLotteryGetDataInfo msg) {
        Asserts.isTrue(promotion087Service.isOpen(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                String.format("活动未开启"));

        Promotion087 promotionInfo = promotion087Service.getPromotionInfo(playerContext.getId());

        ImmutableList<ImmutableThing> cost = promotion087LotteryTypeSysCache.getById(promotionInfo.getLotteryType()).getCost();
        Asserts.isTrue(thingService.enough(playerContext.getId(), cost),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具{%s}数量不足", GsonUtils.toJson(cost)));

        List<Promotion087LotteryRewardConfig> configList = promotion087Service.getConfigList().stream().filter(config ->
                config.getLottery_type() == promotionInfo.getLotteryType() && !promotionInfo.getLotteryRecord().contains(config.getIdx()))
                .collect(Collectors.toList());
        Asserts.isTrue(!configList.isEmpty(), ErrorCode.PROMOTION_IS_CLOSE.getValue(), String.format("活动已关闭"));

        thingService.cost(playerContext.getId(), cost, GameEvent.PROMOTION_087_LOTTERY);

        Promotion087LotteryRewardConfig lotteryRewardConfig = DropUtil.randomDrop(configList);
        thingService.add(playerContext.getId(), lotteryRewardConfig.getRewardThings(), GameEvent.PROMOTION_087_LOTTERY, NoticeType.SLIENT);

        promotionInfo.getLotteryRecord().add(lotteryRewardConfig.getId());

        if (configList.size() <= 1 && promotionInfo.getLotteryType() < promotion087LotteryTypeSysCache.getMaxType()) {
            promotionInfo.setLotteryType(promotionInfo.getLotteryType() + 1);
        }
        promotion087Service.updatePromotion(promotionInfo);

        Promotion087GMsg.GResChristmasLottery.Builder builder = Promotion087GMsg.GResChristmasLottery.newBuilder();
        builder.setLotteryRecord(lotteryRewardConfig.getIdx());
        playerContext.write(CmdCode._76122, builder.build());
    }
}
