package com.ayjs.mxzg.gameserver.module.promotionNew.promotion079;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion079.domain.Promotion079;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion079.service.Promotion079Service;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion079GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 万圣礼包
 */
@Controller
public class Promotion079Handler extends ProtocolHandler {
    @Autowired
    private Promotion079Service promotion079Service;


    @CMD(id = CmdCode._75931)
    public void giftInfo(PlayerContext playerContext, Promotion079GMsg.GReqHalloweenGiftInfo msg) {
        Promotion079 promotionInfo = promotion079Service.getPromotionInfo(playerContext.getId());
        Promotion079GMsg.GResHalloweenGiftInfo.Builder builder = Promotion079GMsg.GResHalloweenGiftInfo.newBuilder();
        promotion079Service.getConfigList().forEach(config -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            data.setValue(promotionInfo.getBuyList().getOrDefault(config.getIdx(), 0));
            builder.addBuy(data);
        });
        playerContext.write(CmdCode._75931, builder.build());

    }
}
