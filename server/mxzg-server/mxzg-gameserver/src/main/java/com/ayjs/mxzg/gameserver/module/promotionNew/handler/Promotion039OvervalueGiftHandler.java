package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion039OvervalueGiftService;
import com.ayjs.mxzg.protocol.Promotion039GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 超值礼包
 */
@Controller
public class Promotion039OvervalueGiftHandler extends ProtocolHandler {

    @Autowired
    private Promotion039OvervalueGiftService promotion039OvervalueGiftService;


    @CMD(id = CmdCode._13181)
    public void getOverValueData(PlayerContext playerContext, Promotion039GMsg.GReqOverValueData msg) {
        promotion039OvervalueGiftService.getOverValueData(playerContext.getId());
    }


}
