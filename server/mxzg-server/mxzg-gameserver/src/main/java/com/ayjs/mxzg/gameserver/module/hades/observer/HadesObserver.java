package com.ayjs.mxzg.gameserver.module.hades.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.remote.large.event.StageCrossConnectEvent;
import com.ayjs.mxzg.message.module.hades.message.HadesRankReqMessage;
import com.ayjs.mxzg.protocol.HadesGMsg;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Observer
public class HadesObserver {

    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;

    @Subscribe
    public void listen(StageCrossConnectEvent event) {
        for (HadesGMsg.HadesType hadesType : HadesGMsg.HadesType.values()) {
            messageDispatcher.dispatch(HadesRankReqMessage.of(hadesType.getNumber(), serverConfig.getServerId()));
        }
    }
}
