package com.ayjs.mxzg.gameserver.module.limitBuy.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.limitBuy.service.LimitProductionService;
import com.ayjs.mxzg.protocol.Task1GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2019/10/31
 **/
@Component
public class LimitProductionHandler extends ProtocolHandler {
    @Autowired
    private LimitProductionService limitProductionService;

    @CMD(id = CmdCode._13060)
    public void limitProductionList(PlayerContext playerContext, Task1GMsg.GReqLimitGiftList req) {
        limitProductionService.sendData(playerContext.getId());
    }

}
