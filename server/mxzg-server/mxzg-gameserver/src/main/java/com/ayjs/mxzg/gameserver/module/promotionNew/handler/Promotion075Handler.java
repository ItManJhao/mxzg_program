package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion075MidFood;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion075MidFoodService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion075GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 赏月佳肴
 */
@Controller
public class Promotion075Handler extends ProtocolHandler {
    @Autowired
    private Promotion075MidFoodService promotion075MidFoodService;
    @Autowired
    private PromotionControlService promotionControlService;

    @CMD(id = CmdCode._75131)
    public void midFoodInfo(PlayerContext playerContext, Promotion075GMsg.GReqMidFoodInfo msg) {
        Promotion075MidFood promotion075MidFood = promotion075MidFoodService.getPromotionInfo(playerContext.getId());
        Promotion075GMsg.GResMidFoodInfo.Builder builder = Promotion075GMsg.GResMidFoodInfo.newBuilder();
        promotion075MidFoodService.getConfigList().forEach(config -> {
            ObjectGMsg.PSMapData.Builder data = ObjectGMsg.PSMapData.newBuilder();
            data.setKey(config.getIdx());
            data.setValue(promotion075MidFood.getBuyList().getOrDefault(config.getIdx(), 0));
            builder.addBuy(data);
        });
        playerContext.write(CmdCode._75131, builder.build());

    }
}
