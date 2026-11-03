package com.ayjs.mxzg.gameserver.module.promotionNew.promotion094;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.promotion094.Promotion094ScoreSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion094.CPromotion094Score;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion094.domain.Promotion094;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion094.service.Promotion094Service;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion094RandomRewardConfig;
import com.ayjs.mxzg.protocol.Promotion094GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;

/**
 * 万圣礼包
 */
@Controller
public class Promotion094Handler extends ProtocolHandler {
    @Autowired
    private Promotion094Service promotion094Service;
    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion094ScoreSysCache promotion094ScoreSysCache;


    @CMD(id = CmdCode._76271)
    public void giftInfo(PlayerContext playerContext, Promotion094GMsg.GReqMakeEggScoreInfo msg) {
        Promotion094 promotionInfo = promotion094Service.getPromotionInfo(playerContext.getId());
        Promotion094GMsg.GResMakeEggScoreInfo.Builder builder = Promotion094GMsg.GResMakeEggScoreInfo.newBuilder();
        builder.setScore(promotionInfo.getScore());
        playerContext.write(CmdCode._76271, builder.build());
    }

    @CMD(id = CmdCode._76272)
    public void exchangeScore(PlayerContext playerContext, Promotion094GMsg.GReqMakeEggExchangeScore msg) {
        Asserts.isTrue(promotion094Service.isOpen(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                String.format("活动未开启"));
        Promotion094 promotionInfo = promotion094Service.getPromotionInfo(playerContext.getId());
        CPromotion094Score config = promotion094ScoreSysCache.getConfig();

        ImmutableList<ImmutableThing> cost = config.getCost_item();
        Asserts.isTrue(thingService.enough(playerContext.getId(), cost),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具{%s}数量不足", GsonUtils.toJson(cost)));

        thingService.cost(playerContext.getId(), cost, GameEvent.PROMOTION_094_EXCHANGE_SCORE);

        promotionInfo.setScore(config.getGet_score() + promotionInfo.getScore());
        promotion094Service.updatePromotion(promotionInfo);

        Promotion094RandomRewardConfig randomRewardConfig = DropUtil.randomDrop(new ArrayList<>(promotion094Service.getConfigList()));
        thingService.add(playerContext.getId(), randomRewardConfig.getRewardThings(), GameEvent.PROMOTION_094_EXCHANGE_SCORE);

        Promotion094GMsg.GResMakeEggExchangeScore.Builder builder = Promotion094GMsg.GResMakeEggExchangeScore.newBuilder();
        builder.setScore(promotionInfo.getScore());
        playerContext.write(CmdCode._76272, builder.build());
    }

    @CMD(id = CmdCode._76273)
    public void openBox(PlayerContext playerContext, Promotion094GMsg.GReqMakeEggBox msg) {
        Asserts.isTrue(promotion094Service.isOpen(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                String.format("活动未开启"));
        Promotion094 promotionInfo = promotion094Service.getPromotionInfo(playerContext.getId());
        CPromotion094Score config = promotion094ScoreSysCache.getConfig();

        Asserts.isTrue(promotionInfo.getScore() >= config.getCost_score(),
                ErrorCode.PROMOTION_094_SCORE_LOW.getValue(),
                String.format("积分{%s}不足", GsonUtils.toJson(promotionInfo.getScore())));

        promotionInfo.setScore(promotionInfo.getScore() - config.getCost_score());
        promotion094Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_094_OPEN_BOX);

        Promotion094GMsg.GResMakeEggBox.Builder builder = Promotion094GMsg.GResMakeEggBox.newBuilder();
        builder.setScore(promotionInfo.getScore());
        playerContext.write(CmdCode._76273, builder.build());
    }
}
