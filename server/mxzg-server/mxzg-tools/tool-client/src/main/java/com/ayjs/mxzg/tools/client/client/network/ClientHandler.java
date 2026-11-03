package com.ayjs.mxzg.tools.client.client.network;

import com.alibaba.fastjson.JSONObject;
import com.ayjs.mxzg.common.netty.GameMessage;
import com.ayjs.mxzg.common.util.MessageUtils;
import com.ayjs.mxzg.tools.client.client.ClientCMD;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandler;
import com.ayjs.mxzg.tools.client.client.base.ClientResponseHandlerRegistry;
import com.ayjs.mxzg.tools.client.client.base.ProtocolRegistry;
import com.ayjs.mxzg.tools.client.simulator.ui.ClientUI;
import com.google.protobuf.Message;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;
import io.netty.handler.timeout.IdleState;
import io.netty.handler.timeout.IdleStateEvent;
import io.netty.util.AttributeKey;
import lombok.extern.slf4j.Slf4j;

import java.util.Objects;

/**
 * 模拟器网络handler
 *
 * @author tangyangbo 2019/8/6 17:00
 */
@Slf4j
public class ClientHandler extends SimpleChannelInboundHandler<Object> {


    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        log.debug("channelActive:{}", ctx.channel().toString());
    }

    @Override
    public void channelInactive(ChannelHandlerContext ctx) throws Exception {
        super.channelInactive(ctx);
        ctx.channel().close();
    }

    @Override
    protected void channelRead0(ChannelHandlerContext ctx, Object msg) throws Exception {
        GameMessage serverMsg = (GameMessage) msg;

        try {
            if (Objects.isNull(serverMsg)) {
                return;
            }
            if (serverMsg.getCmd() <= 0) {
                return;
            }
            AttributeKey<ClientSession> key = AttributeKey.valueOf(ClientCMD.CLIENT_KEY);
            ClientSession clientSession = ctx.channel().attr(key).get();


            log.info("message id: {} ,msg:{}", serverMsg.getCmd(), JSONObject.toJSONString(serverMsg));
            ClientUI.getInstance().addResultText("\n==========" + serverMsg.getCmd() + "========");
//
            Message rspMessage = ProtocolRegistry.getRspMessage(serverMsg.getCmd());
            if (Objects.isNull(rspMessage)) {
                log.error("ProtocolRegistry protocol:{} is not registry.", serverMsg.getCmd());
                return;
            }
            if (serverMsg.getCmd() == ClientCMD.PLAYER_LOGIN_CMD || serverMsg.getCmd() == ClientCMD.PLAYER_REG_CMD) {
//                    client.startHeartBeat();
            }
            ClientUI.getInstance().addResultText(rspMessage.getClass().getSimpleName() + "================\n");
            Message messageData = build(rspMessage, serverMsg.getMsg());
            if (Objects.isNull(messageData)) {
                log.error("protocol:{} is messageData is null.", serverMsg.getCmd());
                return;
            }
            if (ClientUI.getInstance() != null) {
                ClientUI.getInstance().addResultText(MessageUtils.formatMessage(messageData, true));
//                ClientUI.getInstance().addResultText(TextFormat.printToUnicodeString(messageData));
            }

            ClientResponseHandler handler = ClientResponseHandlerRegistry.getHandler(serverMsg.getCmd());
            if (handler == null) {
                log.error("protocol:{} is handler is null.", serverMsg.getCmd());
                return;
            }
            handler.handler(clientSession, messageData);
        } catch (Throwable t) {
            log.error("serverMsg:{}", serverMsg.getCmd());
            log.error("Throwable", t);
        }


    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        log.error("exceptionCaught", cause);
    }

    @Override
    public void userEventTriggered(ChannelHandlerContext ctx, Object evt) throws Exception {
        super.userEventTriggered(ctx, evt);
        if (evt instanceof IdleStateEvent) {
            IdleStateEvent idleStateEvent = (IdleStateEvent) evt;
            if (idleStateEvent.state() == IdleState.READER_IDLE) {
                log.info("client {} IdleStateEvent READER_IDLE.", ctx.channel().remoteAddress());
            }

        }
    }


    protected Message build(Message prototype, byte[] data) {
        try {
            return prototype.getParserForType().parseFrom(data);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
