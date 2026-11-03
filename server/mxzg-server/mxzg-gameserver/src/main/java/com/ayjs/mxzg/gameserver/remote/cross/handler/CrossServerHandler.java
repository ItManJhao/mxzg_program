package com.ayjs.mxzg.gameserver.remote.cross.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.remote.cross.event.CrossConnectedEvent;
import com.ayjs.mxzg.message.cross.AuthenticationIdentityMessage;
import com.ayjs.mxzg.message.cross.CrossConnectedSuccessMessage;
import com.ayjs.mxzg.message.cross.ReportIdentityMessage;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.ErrorCodeMessage;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * 跨服处理器
 */
@Slf4j
@Component
public class CrossServerHandler implements MessageHandler {

    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ContextManager contextManager;


    /**
     * 处理身份认证消息
     *
     * @param message
     * @param connection
     * @return
     */
    @RemoteMethod
    public void handleAuthenticationIdentityMessage(AuthenticationIdentityMessage message, Connection connection) {
        List<Integer> serverIds = Arrays.asList(serverConfig.getSubServerIds());
        connection.send(ReportIdentityMessage.of(serverIds));
        log.info("发送服务器分区信息:{}到Address:{}:", serverIds, connection.getChannel().remoteAddress());
    }

    @RemoteMethod
    public void handleCrossConnectedSuccessMessage(CrossConnectedSuccessMessage message) {
        eventBus.post(CrossConnectedEvent.getInstance());
        log.info("跨服连接完毕!");
    }

    @RemoteMethod
    public void handleErrorCodeMessage(ErrorCodeMessage message){
        PlayerContext context = contextManager.getOnline(message.getRId());
        if(context != null){
            context.writeError(ErrorCode.valueOf(message.getErrorCode()), message.getParams());
        }
    }

}
