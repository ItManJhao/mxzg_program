package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion058HighWeeksCard;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion058HighWeeksCardService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion058GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 高级周卡活动
 *
 * @author hyx
 */
@Controller
public class Promotion058HighWeeksCardHandler extends ProtocolHandler {

    @Autowired
    private Promotion058HighWeeksCardService promotion058HighWeeksCardService;
    @Autowired
    private PromotionControlService promotionControlService;

    @CMD(id = CmdCode._13210)
    public void HighWeeksCardInfo(PlayerContext playerContext, Promotion058GMsg.GReqHighWeeksCardsInfo msg) {

        //Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.GAO_JI_ZHOU_KA), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已结束");

        Promotion058HighWeeksCard promotion058HighWeeksCard = promotion058HighWeeksCardService.getPromotionInfo(playerContext.getId());

        Promotion058GMsg.GResHighWeeksCardsInfo.Builder builder = Promotion058GMsg.GResHighWeeksCardsInfo.newBuilder();

        /*promotion058HighWeeksCard.getBuyList().forEach((k, v) -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(k);
            data.setValue(v);
            builder.setBuy(data);
        });*/

        promotion058HighWeeksCardService.getConfigList().forEach(config -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            data.setValue(promotion058HighWeeksCard.getBuyList().getOrDefault(config.getIdx(), 0));
            builder.setBuy(data);
        });

        playerContext.write(CmdCode._13210, builder.build());

    }
}
