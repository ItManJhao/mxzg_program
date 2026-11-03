package com.ayjs.mxzg.gameserver.module.promotionNew.promotion088;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.promotion088.Promotion088ScoreSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion088.CPromotion088Score;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion088.domain.Promotion088;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion088.service.Promotion088Service;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion088RandomRewardConfig;
import com.ayjs.mxzg.protocol.Promotion088GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;

/**
 * 万圣礼包
 */
@Controller
public class Promotion088Handler extends ProtocolHandler {
    @Autowired
    private Promotion088Service promotion088Service;
    @Autowired
    private ThingService thingService;
    @Autowired
    private Promotion088ScoreSysCache promotion088ScoreSysCache;


    @CMD(id = CmdCode._76141)
    public void giftInfo(PlayerContext playerContext, Promotion088GMsg.GReqChristmasScoreInfo msg) {
        Promotion088 promotionInfo = promotion088Service.getPromotionInfo(playerContext.getId());
        Promotion088GMsg.GResChristmasScoreInfo.Builder builder = Promotion088GMsg.GResChristmasScoreInfo.newBuilder();
        builder.setScore(promotionInfo.getScore());
        playerContext.write(CmdCode._76141, builder.build());
    }

    @CMD(id = CmdCode._76142)
    public void exchangeScore(PlayerContext playerContext, Promotion088GMsg.GReqChristmasExchangeScore msg) {
        Asserts.isTrue(promotion088Service.isOpen(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                String.format("活动未开启"));
        Promotion088 promotionInfo = promotion088Service.getPromotionInfo(playerContext.getId());
        CPromotion088Score config = promotion088ScoreSysCache.getConfig();

        ImmutableList<ImmutableThing> cost = config.getCost_item();
        Asserts.isTrue(thingService.enough(playerContext.getId(), cost),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具{%s}数量不足", GsonUtils.toJson(cost)));

        thingService.cost(playerContext.getId(), cost, GameEvent.PROMOTION_088_EXCHANGE_SCORE);

        promotionInfo.setScore(config.getGet_score() + promotionInfo.getScore());
        promotion088Service.updatePromotion(promotionInfo);

        Promotion088RandomRewardConfig randomRewardConfig = DropUtil.randomDrop(new ArrayList<>(promotion088Service.getConfigList()));
        thingService.add(playerContext.getId(), randomRewardConfig.getRewardThings(), GameEvent.PROMOTION_088_EXCHANGE_SCORE);

        Promotion088GMsg.GResChristmasExchangeScore.Builder builder = Promotion088GMsg.GResChristmasExchangeScore.newBuilder();
        builder.setScore(promotionInfo.getScore());
        playerContext.write(CmdCode._76142, builder.build());
    }

    @CMD(id = CmdCode._76143)
    public void openBox(PlayerContext playerContext, Promotion088GMsg.GReqChristmasExchangeScore msg) {
        Asserts.isTrue(promotion088Service.isOpen(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                String.format("活动未开启"));
        Promotion088 promotionInfo = promotion088Service.getPromotionInfo(playerContext.getId());
        CPromotion088Score config = promotion088ScoreSysCache.getConfig();

        Asserts.isTrue(promotionInfo.getScore() >= config.getCost_score(),
                ErrorCode.PROMOTION_088_SCORE_LOW.getValue(),
                String.format("积分{%s}不足", GsonUtils.toJson(promotionInfo.getScore())));

        promotionInfo.setScore(promotionInfo.getScore() - config.getCost_score());
        promotion088Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_088_OPEN_BOX);

        Promotion088GMsg.GResChristmasBox.Builder builder = Promotion088GMsg.GResChristmasBox.newBuilder();
        builder.setScore(promotionInfo.getScore());
        playerContext.write(CmdCode._76143, builder.build());
    }
}
