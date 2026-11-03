package com.ayjs.mxzg.common.netty;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandler.Sharable;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelOutboundHandlerAdapter;
import io.netty.channel.ChannelPromise;

/**
 * 大端序编码器
 */
@Sharable
public class IOEncoder extends ChannelOutboundHandlerAdapter {

	@Override
	public void write(ChannelHandlerContext ctx, Object msg, ChannelPromise promise) {
		GameMessage message = (GameMessage) msg;
		//申请长度为4+消息长度的ByteBuf
		//|4字节长度|4字节协议号|protobuf包体|
		final ByteBuf buffer = ctx.alloc().buffer(message.getMsg().length + 4 + 4);
		//先写入消息的长度
		buffer.writeInt(message.getMsg().length + 4);
		buffer.writeInt(message.getCmd());
		//再写入消息
		buffer.writeBytes(message.getMsg());
		ctx.writeAndFlush(buffer);
	}
}
