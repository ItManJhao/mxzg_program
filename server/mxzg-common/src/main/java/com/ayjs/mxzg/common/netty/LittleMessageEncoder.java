package com.ayjs.mxzg.common.netty;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandler.Sharable;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.MessageToByteEncoder;

/**
 * 小端序编码器
 */
@Sharable
public class LittleMessageEncoder extends MessageToByteEncoder<GameMessage> {

	@Override
	protected void encode(ChannelHandlerContext channelHandlerContext, GameMessage message, ByteBuf byteBuf) throws Exception {
		//先写入消息的长度
		byteBuf.writeIntLE(message.getMsg().length + 4);
		byteBuf.writeIntLE(message.getCmd());
		//再写入消息
		byteBuf.writeBytes(message.getMsg());
	}

	@Override
	protected ByteBuf allocateBuffer(ChannelHandlerContext ctx, GameMessage msg, boolean preferDirect) throws Exception {
		try {
			int packetLength = msg.getMsg().length;
			if (packetLength > CoderConstant.PACKET_MAX_LENGTH) {
				throw new PacketTooLongException(String.format("请求cmd:%s包体过长length:%s", msg.getCmd(), packetLength));
			}
			return ctx.alloc().buffer(8 + msg.getMsg().length, CoderConstant.PACKET_MAX_LENGTH);
		} catch (PacketTooLongException ex) {
			ex.printStackTrace();
		}
		return ctx.alloc().buffer(CoderConstant.BODY_EXCEPT_BYTE_LENGTH, CoderConstant.PACKET_MAX_LENGTH);
	}
}
