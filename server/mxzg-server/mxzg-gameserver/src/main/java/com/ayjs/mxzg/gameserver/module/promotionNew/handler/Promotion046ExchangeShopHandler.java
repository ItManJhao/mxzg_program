package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion046ExchangeShop;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion046ExchangeShopService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion046ExchangeShopConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion045GMsg;
import com.ayjs.mxzg.protocol.Promotion046GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 碎片进化
 *
 * @Author: CWJ
 * @Date: 2019/11/3
 **/
@Component
public class Promotion046ExchangeShopHandler extends ProtocolHandler {

    @Autowired
    private Promotion046ExchangeShopService promotion044FiresShopService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private PromotionControlService promotionControlService;

    @CMD(id = CmdCode._13162)
    public void sendData(PlayerContext playerContext, Promotion046GMsg.GReqExchangeShopData req) {
        Promotion046GMsg.GResExchangeShopData.Builder builder = Promotion046GMsg.GResExchangeShopData.newBuilder();
        Promotion046ExchangeShop promotion = promotion044FiresShopService.getPromotionInfo(playerContext.getId());
        promotion.getRewardRecord().forEach((id, count) -> {
            ObjectGMsg.PSMapData.Builder recordBuilder = ObjectGMsg.PSMapData.newBuilder();
            recordBuilder.setKey(id);
            recordBuilder.setValue(count);
            builder.addExchangeRecord(recordBuilder.build());
        });
        playerContext.write(CmdCode._13162, builder.build());
    }

    @CMD(id = CmdCode._13163)
    public void reward(PlayerContext playerContext, Promotion045GMsg.GReqLoginGiftReward req) {

        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.SUI_PIAN_JIN_HUA),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动{%s}已关闭!", PromotionType.SUI_PIAN_JIN_HUA));

        Promotion046ExchangeShopConfig config = promotion044FiresShopService.getConfig(req.getIdx());
        Promotion046ExchangeShop promotionInfo = promotion044FiresShopService.getPromotionInfo(playerContext.getId());
        Asserts.notNull(config, ErrorCode.CONFIG_NOT_EXIST.getValue(), String.format("活动配置{%s}不存在!", req.getIdx()));

        int buyCount = promotionInfo.getRewardRecord().getOrDefault(req.getIdx(), 0);
        Asserts.isTrue(buyCount < config.getLimit()
                , ErrorCode.PROMOTION_TOOK_REWARD.getValue(), String.format("已购买数量{%s},先知数量{%s}", buyCount, config.getLimit()));

        thingService.cost(playerContext.getId(), ImmutableThingUtil.fromJson(config.getNeed_item()), GameEvent.EXCHANGE_SHOP);

        promotionInfo.getRewardRecord().put(req.getIdx(), buyCount + 1);
        promotion044FiresShopService.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), ImmutableThingUtil.fromJson(config.getReward()), GameEvent.EXCHANGE_SHOP);

        Promotion046GMsg.GResExchangeShopReward.Builder builder = Promotion046GMsg.GResExchangeShopReward.newBuilder();
        builder.setIdx(req.getIdx());
        playerContext.write(CmdCode._13163, builder.build());

    }

}
