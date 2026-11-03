package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion044FiresShop;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion044FiresShopService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion044FiresShopConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion044GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 七彩华章
 *
 * @Author: CWJ
 * @Date: 2019/11/3
 **/
@Component
public class Promotion044FiresShopHandler extends ProtocolHandler {

    @Autowired
    private Promotion044FiresShopService promotion044FiresShopService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private PromotionControlService promotionControlService;

    @CMD(id = CmdCode._13166)
    public void sendData(PlayerContext playerContext, Promotion044GMsg.GReqColourfulShopData req) {
        Promotion044GMsg.GResColourfulShopData.Builder builder = Promotion044GMsg.GResColourfulShopData.newBuilder();
        Promotion044FiresShop promotion = promotion044FiresShopService.getPromotionInfo(playerContext.getId());
        promotion.getFiresShopInfo().forEach((id, count) -> {
            ObjectGMsg.PSMapData.Builder buyInfoBuilder = ObjectGMsg.PSMapData.newBuilder();
            buyInfoBuilder.setKey(id);
            buyInfoBuilder.setValue(count);
            builder.addBuyInfo(buyInfoBuilder.build());
        });
        //  thingService.add(playerContext.getId(), ImmutableThing.of(901702, 1000), GameEvent.LEVEL_REWARD);
        playerContext.write(CmdCode._13166, builder.build());
    }

    @CMD(id = CmdCode._13167)
    public void reward(PlayerContext playerContext, Promotion044GMsg.GReqColourfulShopReward req) {

        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.QI_CAI_HUA_ZHANG),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动{%s}已关闭!", PromotionType.QI_CAI_HUA_ZHANG));

        Promotion044FiresShopConfig config = promotion044FiresShopService.getConfig(req.getIdx());
        Promotion044FiresShop promotionInfo = promotion044FiresShopService.getPromotionInfo(playerContext.getId());

        Asserts.notNull(config, ErrorCode.CONFIG_NOT_EXIST.getValue(), String.format("活动配置{%s}不存在!", req.getIdx()));
        int buyCount = promotionInfo.getFiresShopInfo().getOrDefault(req.getIdx(), 0);

        int num = req.getNum();
        Asserts.isTrue(buyCount + num <= config.getLimit()
                , ErrorCode.PROMOTION_TOOK_REWARD.getValue(), String.format("已购买数量{%s},先知数量{%s}", buyCount, config.getLimit()));
        ImmutableList<ImmutableThing> cost = ImmutableThingUtil.fromJson(config.getCost());
        thingService.cost(playerContext.getId(), ImmutableThingUtil.multiplyThing(cost, num), GameEvent.FIRES_SHOP);

        promotionInfo.getFiresShopInfo().put(req.getIdx(), buyCount + num);
        promotion044FiresShopService.updatePromotion(promotionInfo);

        ImmutableList<ImmutableThing> reward = ImmutableThingUtil.fromJson(config.getItem());
        thingService.add(playerContext.getId(), ImmutableThingUtil.multiplyThing(reward, num), GameEvent.FIRES_SHOP);

        Promotion044GMsg.GResColourfulShopReward.Builder builder = Promotion044GMsg.GResColourfulShopReward.newBuilder();
        builder.setIdx(req.getIdx());
        builder.setNum(req.getNum());
        playerContext.write(CmdCode._13167, builder.build());

    }

}
