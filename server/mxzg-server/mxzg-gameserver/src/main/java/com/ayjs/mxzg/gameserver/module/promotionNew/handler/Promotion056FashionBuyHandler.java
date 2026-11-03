package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion054FlashSaleSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion054FlashSale;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion054FlashSale;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion056FashionBuy;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion054FlashSaleService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion056FashionBuyService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion054GMsg;
import com.ayjs.mxzg.protocol.Promotion056GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 皮肤活动
 */
@Component
public class Promotion056FashionBuyHandler extends ProtocolHandler {

    @Autowired
    private Promotion056FashionBuyService promotion056FashionBuyService;

    @CMD(id = CmdCode._64001)
    public void sendData(PlayerContext playerContext, Promotion056GMsg.GReqFashionBuyData req) {
        Promotion056FashionBuy promotionInfo = promotion056FashionBuyService.getPromotionInfo(playerContext.getId());
        Promotion054GMsg.GResFlashSaleData.Builder builder = Promotion054GMsg.GResFlashSaleData.newBuilder();
        promotionInfo.getBuyCount().forEach((key, value) -> {
            builder.addRewardCount(PbUtil.builderMap(key, value));
        });
        playerContext.write(CmdCode._64001, builder.build());
    }


}
