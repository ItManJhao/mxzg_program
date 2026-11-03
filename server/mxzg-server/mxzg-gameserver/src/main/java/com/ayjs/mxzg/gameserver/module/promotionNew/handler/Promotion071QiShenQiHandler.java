package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion071QiShenQi;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion071QiShenQiService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion071GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import com.ayjs.mxzg.common.handler.CMD;

/**
 * 七神器
 */
@Controller
public class Promotion071QiShenQiHandler extends ProtocolHandler {
    @Autowired
    private Promotion071QiShenQiService promotion071QiShenQiService;
    @Autowired
    private PromotionControlService promotionControlService;

    @CMD(id = CmdCode._75101)
    public void qiShenQiInfo(PlayerContext playerContext, Promotion071GMsg.GReqQiShenQiInfo msg) {
        Promotion071QiShenQi promotion071QiShenQi = promotion071QiShenQiService.getPromotionInfo(playerContext.getId());
        Promotion071GMsg.GResQiShenQiInfo.Builder builder = Promotion071GMsg.GResQiShenQiInfo.newBuilder();
        promotion071QiShenQiService.getConfigList().forEach(config -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            data.setValue(promotion071QiShenQi.getBuyList().getOrDefault(config.getIdx(), 0));
            builder.addBuy(data);
        });
        playerContext.write(CmdCode._75101, builder.build());

    }
}
