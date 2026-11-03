package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion042SacrificeShopBuy;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion042SacrificeShopService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion042SacrificesShopConfig;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion042GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Map;
import java.util.Objects;

/**
 * 祭坛兑换
 */
@Controller
public class Promotion042SacrificeShopHandler extends ProtocolHandler {

    @Autowired
    private Promotion042SacrificeShopService promotion042SacrificeShopService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;


    /**
     * 祭坛兑换活动
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13095)
    public void sacrificeShop(PlayerContext playerContext, Promotion042GMsg.GReqPromotionSacrificeShop msg) {
        Promotion042GMsg.GResPromotionSacrificeShop.Builder builder = Promotion042GMsg.GResPromotionSacrificeShop.newBuilder();

        Promotion042SacrificeShopBuy promotion042SacrificeShopBuy =
                promotion042SacrificeShopService.getPromotionInfo(playerContext.getId());

        for (Promotion042SacrificesShopConfig config : promotion042SacrificeShopService.selectConfigList()) {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            if (promotion042SacrificeShopBuy.getBuyMap().get(config.getIdx()) != null) {
                data.setValue(promotion042SacrificeShopBuy.getBuyMap().get(config.getIdx()));
            } else {
                data.setValue(0);
            }
            builder.addList(data);
        }

        playerContext.write(CmdCode._13095, builder.build());
    }


    /**
     * 祭坛兑换活动兑换
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._50003)
    public void shopBuySacrifice(PlayerContext playerContext, Promotion042GMsg.GReqShopBuySacrifice msg) {

        Promotion042GMsg.GResShopBuySacrifice.Builder builder = Promotion042GMsg.GResShopBuySacrifice.newBuilder();

        if (!promotionControlService.isPromotionRunning(PromotionType.JI_TAN_DUI_HUAN)) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_TIME.getValue(), "PromotionType.JI_TAN_DUI_HUAN");
        }

        Promotion042SacrificeShopBuy promotion042SacrificeShopBuy =
                promotion042SacrificeShopService.getPromotionInfo(playerContext.getId());
        Map<Integer, Integer> buyMap = promotion042SacrificeShopBuy.getBuyMap();
        buyMap.putIfAbsent(msg.getIdx(), 0);

        Promotion042SacrificesShopConfig config = promotion042SacrificeShopService.selectConfigOne(msg.getIdx());
        if (Objects.isNull(config)) {
            throw new ErrorCodeException(ErrorCode.CONFIG_NOT_EXISTS.getValue(), "PromotionType.JI_TAN_DUI_HUAN，活动配置不存在");
        }

        if (config.getBuy_limit() > 0 && buyMap.get(msg.getIdx()) >= config.getBuy_limit()) {

            throw new ErrorCodeException(ErrorCode.PROMOTION_SACRIFICE_SHOP_BUY_LIMIT.getValue(), "PromotionType.JI_TAN_DUI_HUAN，" +
                    "祭坛商店购买的商品达到限购次数，当前已购买次数：" + buyMap.get(msg.getIdx()));

        }

        thingService.cost(playerContext.getId(), ImmutableThingUtil.fromJson(config.getNeed_item()), GameEvent.SHOP_BUY_SACRIFICE);

        buyMap.put(msg.getIdx(), buyMap.get(msg.getIdx()) + 1);
        promotion042SacrificeShopBuy.setBuyMap(buyMap);
        promotion042SacrificeShopService.updatePromotion(promotion042SacrificeShopBuy);

        thingService.add(playerContext.getId(), ImmutableThingUtil.fromJson(config.getItem_type()), GameEvent.SHOP_BUY_SACRIFICE, NoticeType.NORMAL);

        builder.setIdx(msg.getIdx());
        playerContext.write(CmdCode._50003, builder.build());
    }

}
