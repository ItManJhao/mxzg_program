package com.ayjs.mxzg.gameserver.module.promotionNew.promotion082;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion082.domain.Promotion082;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion082.service.Promotion082Service;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion082GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 万圣礼包
 */
@Controller
public class Promotion082Handler extends ProtocolHandler {
    @Autowired
    private Promotion082Service promotion082Service;


    @CMD(id = CmdCode._76021)
    public void giftInfo(PlayerContext playerContext, Promotion082GMsg.GReqBlackFiveGiftInfo msg) {
        Promotion082 promotionInfo = promotion082Service.getPromotionInfo(playerContext.getId());
        Promotion082GMsg.GResBlackFiveGiftInfo.Builder builder = Promotion082GMsg.GResBlackFiveGiftInfo.newBuilder();
        promotion082Service.getConfigList().forEach(config -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            data.setValue(promotionInfo.getBuyList().getOrDefault(config.getIdx(), 0));
            builder.addBuy(data);
        });
        playerContext.write(CmdCode._76021, builder.build());

    }
}
