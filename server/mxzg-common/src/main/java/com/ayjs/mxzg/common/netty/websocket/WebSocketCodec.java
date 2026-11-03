package com.ayjs.mxzg.common.netty.websocket;

import com.ayjs.mxzg.common.netty.GameMessage;
import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandler;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.MessageToMessageCodec;
import io.netty.handler.codec.http.websocketx.BinaryWebSocketFrame;
import io.netty.handler.codec.http.websocketx.WebSocketFrame;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

/**
 * 编码解码器
 */
@Slf4j
@ChannelHandler.Sharable
public class WebSocketCodec extends MessageToMessageCodec<WebSocketFrame, GameMessage> {
    @Override
    protected void encode(ChannelHandlerContext ctx, GameMessage message, List<Object> out) throws Exception {
        //申请长度为4+消息长度的ByteBuf
        //|4字节长度|4字节协议号|protobuf包体|
        ByteBuf buffer = ctx.alloc().buffer(message.getMsg().length + 4 + 4);
        //先写入消息的长度
        buffer.writeInt(message.getMsg().length + 4);
        buffer.writeInt(message.getCmd());
        //再写入消息
        buffer.writeBytes(message.getMsg());
        BinaryWebSocketFrame frame = new BinaryWebSocketFrame(buffer);
        out.add(frame);
    }

    @Override
    protected void decode(ChannelHandlerContext ctx, WebSocketFrame frame, List<Object> out) throws Exception {
        if (frame instanceof BinaryWebSocketFrame) {
            ByteBuf buffer = frame.content();
            int size = buffer.readableBytes();
            //当前流中的数组长度还小于4，不符合一个完整消息的规定，需要等流收集到足够的数据才继续处理
            if (size < 8) {
                return;
            }
            //读取一个int来确认消息的长度，并使读取索引移动4位
            int dataLength = buffer.readInt();
            //协议号
            if (dataLength <= 0 || dataLength > size - 4) {
                //当流中的数据长度没有达到消息长度的要求时，说明该消息还没有被完全读取，
                //需要等流收集到足够的数据时才能继续处理
                //但上述的readInt时数组索引已经移动了4位，所以需要把读取索引重设回标记读取索引的位置
                buffer.resetReaderIndex();
                return;
            }
            int cmd = buffer.readInt();
            byte[] decoded = new byte[dataLength - 4];
            buffer.readBytes(decoded);
            //标记数组的读取索引
            buffer.markReaderIndex();

            GameMessage message = new GameMessage();
            message.setCmd(cmd);
            message.setMsg(decoded);

            out.add(message);
        } else {
            log.warn("unsupported frame type = {}, channelId={}", frame.getClass(), ctx.channel().id().asLongText());
        }
    }
}
