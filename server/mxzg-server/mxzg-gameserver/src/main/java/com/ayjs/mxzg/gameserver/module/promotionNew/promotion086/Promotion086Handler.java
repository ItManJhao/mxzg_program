package com.ayjs.mxzg.gameserver.module.promotionNew.promotion086;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion086.domain.Promotion086;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion086.service.Promotion086Service;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion086GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 万圣礼包
 */
@Controller
public class Promotion086Handler extends ProtocolHandler {
    @Autowired
    private Promotion086Service promotion086Service;


    @CMD(id = CmdCode._76101)
    public void giftInfo(PlayerContext playerContext, Promotion086GMsg.GReqChristmasGiftInfo msg) {
        Promotion086 promotionInfo = promotion086Service.getPromotionInfo(playerContext.getId());
        Promotion086GMsg.GResChristmasGiftInfo.Builder builder = Promotion086GMsg.GResChristmasGiftInfo.newBuilder();
        promotion086Service.getConfigList().forEach(config -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            data.setValue(promotionInfo.getBuyList().getOrDefault(config.getIdx(), 0));
            builder.addBuy(data);
        });
        playerContext.write(CmdCode._76101, builder.build());
    }
}
