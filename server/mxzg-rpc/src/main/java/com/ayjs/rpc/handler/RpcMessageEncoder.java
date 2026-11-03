package com.ayjs.rpc.handler;

import com.alibaba.fastjson.JSON;
import com.ayjs.rpc.HeartbeatMessage;
import com.ayjs.rpc.RpcMessage;
import com.ayjs.rpc.client.Request;
import com.ayjs.rpc.codec.RpcCodec;
import com.ayjs.rpc.server.Response;
import com.ayjs.rpc.util.InstanceFactory;
import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.MessageToByteEncoder;
import lombok.extern.slf4j.Slf4j;

/**
 * 编码
 *
 * @author Alias
 * @date 2018年1月9日 下午3:22:42
 */
@Slf4j
public class RpcMessageEncoder extends MessageToByteEncoder<RpcMessage> {

    @Override
    protected void encode(ChannelHandlerContext ctx, RpcMessage msg, ByteBuf out) {
        if (msg instanceof Response) {
            encodeResponse(ctx, msg, out);
            if (log.isDebugEnabled()) {
                Response response = (Response) msg;
                log.debug("--->响应响应消息{}内容:{}", response.getResult().getClass(), JSON.toJSON(response.getResult()));
            }
        } else if (msg instanceof Request) {
            encodeRequest(ctx, msg, out);
            if (log.isDebugEnabled()) {
                Request request = (Request) msg;
                if (!(request.getMessage() instanceof HeartbeatMessage)) {
                    log.debug("--->响应请求消息{}内容:{}", request.getMessage().getClass(), JSON.toJSON(request.getMessage()));
                }
            }
        }
    }

    private void encodeRequest(ChannelHandlerContext ctx, RpcMessage msg, ByteBuf buf) {
        Request request = (Request) msg;
        byte[] data = InstanceFactory.getInstance(RpcCodec.class).encode(request);
        buf.writeInt(data.length + 1);
        buf.writeByte(RpcMessage.REQUEST);
        buf.writeBytes(data);
    }

    private void encodeResponse(ChannelHandlerContext ctx, RpcMessage msg, ByteBuf buf) {
        Response response = (Response) msg;
        byte[] data = InstanceFactory.getInstance(RpcCodec.class).encode(response);
        buf.writeInt(data.length + 1);
        buf.writeByte(RpcMessage.RESPONSE);
        buf.writeBytes(data);
    }
}
