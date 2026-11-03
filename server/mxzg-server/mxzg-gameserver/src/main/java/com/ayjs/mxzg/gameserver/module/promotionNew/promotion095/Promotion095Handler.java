package com.ayjs.mxzg.gameserver.module.promotionNew.promotion095;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion095.domain.Promotion095;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion095.service.Promotion095Service;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion095GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 万圣礼包
 */
@Controller
public class Promotion095Handler extends ProtocolHandler {
    @Autowired
    private Promotion095Service promotion095Service;


    @CMD(id = CmdCode._76281)
    public void giftInfo(PlayerContext playerContext, Promotion095GMsg.GReqSpringOutingGiftInfo msg) {
        Promotion095 promotionInfo = promotion095Service.getPromotionInfo(playerContext.getId());
        Promotion095GMsg.GResSpringOutingGiftInfo.Builder builder = Promotion095GMsg.GResSpringOutingGiftInfo.newBuilder();
        promotion095Service.getConfigList().forEach(config -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            data.setValue(promotionInfo.getBuyList().getOrDefault(config.getIdx(), 0));
            builder.addBuy(data);
        });
        playerContext.write(CmdCode._76281, builder.build());
    }
}
