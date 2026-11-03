package com.ayjs.mxzg.gameserver.module.promotionNew.handler;


import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion058HighWeeksCard;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion059SummonWeeksCard;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion058HighWeeksCardService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion059SummonWeeksCardService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion058GMsg;
import com.ayjs.mxzg.protocol.Promotion059GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 召唤周卡活动
 * @author hyx
 */
@Controller
public class Promotion059SummonWeeksCardHandler extends ProtocolHandler {

    @Autowired
    private Promotion059SummonWeeksCardService promotion059SummonWeeksCardService;
    @Autowired
    private PromotionControlService promotionControlService;

    @CMD(id = CmdCode._13220)
    public void HighWeeksCardInfo(PlayerContext playerContext, Promotion059GMsg.GReqSummonWeeksCardsInfo msg) {

        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.ZHAO_HUAN_ZHOU_KA), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已结束");

        Promotion059SummonWeeksCard promotion059SummonWeeksCard = promotion059SummonWeeksCardService.getPromotionInfo(playerContext.getId());

        Promotion059GMsg.GResSummonWeeksCardsInfo.Builder builder = Promotion059GMsg.GResSummonWeeksCardsInfo.newBuilder();

       /* promotion059SummonWeeksCard.getBuyList().forEach((k, v) -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(k);
            data.setValue(v);
            builder.setBuy(data);
        });*/

        promotion059SummonWeeksCardService.getConfigList().forEach(config -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            data.setValue(promotion059SummonWeeksCard.getBuyList().getOrDefault(config.getIdx(), 0));
            builder.setBuy(data);
        });

        playerContext.write(CmdCode._13220, builder.build());

    }

}
