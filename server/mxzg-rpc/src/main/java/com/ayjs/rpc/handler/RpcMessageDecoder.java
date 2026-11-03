package com.ayjs.rpc.handler;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.ByteToMessageDecoder;

import java.util.List;

import com.ayjs.rpc.RpcMessage;
import com.ayjs.rpc.client.Request;
import com.ayjs.rpc.codec.RpcCodec;
import com.ayjs.rpc.server.Response;
import com.ayjs.rpc.util.InstanceFactory;

/**
 * 解码
 *
 * @author Alias
 * @date 2018年1月9日 上午11:25:25
 */
public class RpcMessageDecoder extends ByteToMessageDecoder {

    @Override
    protected void decode(ChannelHandlerContext ctx, ByteBuf in, List<Object> out) throws Exception {
        int length = in.readableBytes() - 1;
        int type = in.readByte();
        if (isRequest(type)) {
            out.add(decodeRequest(in, length));
            return;
        }
        if (isResponse(type)) {
            out.add(decodeResponse(in, length));
        }
    }

    private Response decodeResponse(ByteBuf buf, int length) {
        byte[] data = new byte[length];
        buf.readBytes(data);
        return InstanceFactory.getInstance(RpcCodec.class).decode(Response.class, data);
    }

    private Request decodeRequest(ByteBuf buf, int length) {
        byte[] data = new byte[length];
        buf.readBytes(data);
        return InstanceFactory.getInstance(RpcCodec.class).decode(Request.class, data);
    }

    private boolean isResponse(int type) {
        return type == RpcMessage.RESPONSE;
    }

    private boolean isRequest(int type) {
        return type == RpcMessage.REQUEST;
    }
}
