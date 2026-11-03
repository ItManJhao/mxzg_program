package com.ayjs.mxzg.gameserver.module.timeLimitItem.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.timeLimitItem.service.LimitItemInfoService;
import com.ayjs.mxzg.protocol.BackPackGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @author hyx
 */
@Controller
public class LimitItemInfoHandler extends ProtocolHandler {

    @Autowired
    private LimitItemInfoService limitItemInfoService;

    @CMD(id = CmdCode._5010)
    public void weeksCardInfo(PlayerContext playerContext, BackPackGMsg.GReqTimeLimitList msg) {
        limitItemInfoService.sendLimitItemInfo(playerContext.getId());
    }
}
