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
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion054FlashSaleService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion054GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 限时抢购
 */
@Component
public class Promotion054FlashSaleHandler extends ProtocolHandler {

    @Autowired
    private Promotion054FlashSaleService promotion054FlashSaleService;
    @Autowired
    private Promotion054FlashSaleSysCache promotion054FlashSaleSysCache;
    @Autowired
    private PromotionControlService promotionControlService;

    @CMD(id = CmdCode._54001)
    public void sendData(PlayerContext playerContext, Promotion054GMsg.GReqFlashSaleData req) {
        Promotion054FlashSale promotionInfo = promotion054FlashSaleService.getPromotionInfo(playerContext.getId());
        PromotionControl control = promotionControlService.getControl(PromotionType.XIAN_SHI_QIANG_GOU);
        List<CPromotion054FlashSale> configsByTurn = promotion054FlashSaleSysCache.getConfigsByTurn(control.getTurns());
        Promotion054GMsg.GResFlashSaleData.Builder builder = Promotion054GMsg.GResFlashSaleData.newBuilder();
        if (CollectionUtil.isNotEmpty(configsByTurn)) {
            configsByTurn.forEach(config -> {
                int count = promotion054FlashSaleService.getCount(promotionInfo, config);
                ObjectGMsg.PSMapData.Builder mapDataBuilder = ObjectGMsg.PSMapData.newBuilder();
                mapDataBuilder.setKey(config.getIdx());
                mapDataBuilder.setValue(count);
                builder.addRewardCount(mapDataBuilder);
            });
        }
        playerContext.write(CmdCode._54001, builder.build());
    }


}
