package com.ayjs.mxzg.gameserver.module.promotionNew.promotion076;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.config.excel.cache.promotion076.Promotion076FashionCountRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion076.CPromotion076FashionCountReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion076.converter.Promotion076PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion076.domain.Promotion076;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion076.service.Promotion076Service;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion076ExchangeRewardConfig;
import com.ayjs.mxzg.protocol.Promotion076GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion076Handler extends ProtocolHandler {

    @Autowired
    private Promotion076Service promotion076Service;
    @Autowired
    private Promotion076PB promotion076PB;
    @Autowired
    private ThingService thingService;

    @Autowired
    private Promotion076FashionCountRewardSysCache promotion076FashionCountRewardSysCache;

    @CMD(id = CmdCode._75821)
    public void getData(PlayerContext playerContext, Promotion076GMsg.GReqMidFashionGetDataInfo req) {
        if (!promotion076Service.isOpening()) {
            playerContext.write(CmdCode._75821, Promotion076GMsg.GResMidFashionGetDataInfo.getDefaultInstance());
            return;
        }
        playerContext.write(CmdCode._75821, promotion076PB.buildData(promotion076Service.getPromotionInfo(playerContext.getId())));
    }

    @CMD(id = CmdCode._75822)
    public void getFashionCount(PlayerContext playerContext, Promotion076GMsg.GResMidFashionGetFashionCount req) {
        Asserts.isTrue(promotion076Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        CPromotion076FashionCountReward config = promotion076FashionCountRewardSysCache.getOrThrow(req.getIdx());
        Promotion076 promotionInfo = promotion076Service.getPromotionInfo(playerContext.getId());

        Asserts.isTrue(thingService.enough(playerContext.getId(), config.getNeed_item()),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具数量不足{%s}", GJsonUtils.toJson(config.getNeed_item())));

        Asserts.isTrue(!promotionInfo.getFashionCountRecord().contains(config.getIdx()),
                ErrorCode.PROMOTION_076_FASHION_COUNT_HAD_REWARD.getValue(),
                String.format("已经领取{%s}-{%s}", config.getIdx(), GJsonUtils.toJson(promotionInfo.getFashionCountRecord())));

        promotionInfo.getFashionCountRecord().add(config.getIdx());
        promotion076Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_074_MISSION_BOX_REWARD);
        playerContext.write(CmdCode._75822, promotion076PB.buildGetFashionCount(config.getIdx()));
    }

    @CMD(id = CmdCode._75823)
    public void exchangeFashion(PlayerContext playerContext, Promotion076GMsg.GReqMidFashionExchangeFashion req) {
        Asserts.isTrue(promotion076Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        Promotion076ExchangeRewardConfig config = promotion076Service.getConfig(req.getIdx());
        Promotion076 promotionInfo = promotion076Service.getPromotionInfo(playerContext.getId());

        List<Integer> allCountIds = promotion076FashionCountRewardSysCache.getAll().stream().mapToInt(CPromotion076FashionCountReward::getIdx)
                .collect(ArrayList::new, ArrayList::add, ArrayList::addAll);

        Asserts.isTrue(promotionInfo.getFashionCountRecord().containsAll(allCountIds),
                ErrorCode.PROMOTION_076_FASHION_COUNT_HAD_REWARD.getValue(),
                String.format("存在id皮肤数量未领取{%s}",GJsonUtils.toJson(promotionInfo.getFashionCountRecord())));

        Asserts.isTrue(thingService.enough(playerContext.getId(), config.getNeedItemThings()),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具数量不足{%s}", GJsonUtils.toJson(config.getNeedItemThings())));

        thingService.cost(playerContext.getId(), config.getNeedItemThings(),GameEvent.PROMOTION_074_FASHION_EXCHANGE_COST);

        promotionInfo.getFashionCountRecord().clear();
        promotion076Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getRewardThings(), GameEvent.PROMOTION_074_FASHION_EXCHANGE_REWARD);
        playerContext.write(CmdCode._75823,promotion076PB.buildExchange(promotionInfo));
    }


}
