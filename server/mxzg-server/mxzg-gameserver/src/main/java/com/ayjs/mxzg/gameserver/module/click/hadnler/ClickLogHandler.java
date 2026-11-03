package com.ayjs.mxzg.gameserver.module.click.hadnler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.log.click.domain.ClickLog;
import com.ayjs.mxzg.gameserver.module.click.event.ClickEvent;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage;
import com.ayjs.mxzg.protocol.ClickGMsg;
import com.ayjs.rpc.dispatcher.MessageHandler;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @Author: CWJ
 * @Date: 2020/3/11
 **/
public class ClickLogHandler extends ProtocolHandler implements MessageHandler {

    @Autowired
    private EventBus eventBus;

    @CMD(id = CmdCode._60001)
    public void scanWorldBoss(PlayerContext playerContext, ClickGMsg.GResClick msg) {
        eventBus.post(ClickEvent.of(playerContext.getId(), msg.getClickCode()));
    }

}
