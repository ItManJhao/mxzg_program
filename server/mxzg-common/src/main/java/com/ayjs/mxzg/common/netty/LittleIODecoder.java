package com.ayjs.mxzg.common.netty;

import io.netty.buffer.ByteBuf;
import io.netty.channel.ChannelHandlerContext;
import io.netty.handler.codec.ByteToMessageDecoder;

import java.util.List;

/**
 * 小端序解码器
 */
public class LittleIODecoder extends ByteToMessageDecoder {

	@Override
	protected void decode(ChannelHandlerContext ctx, ByteBuf buffer, List<Object> out) throws Exception {
		int size = buffer.readableBytes();
		//当前流中的数组长度还小于4，不符合一个完整消息的规定，需要等流收集到足够的数据才继续处理
		if (size < 8) {
			return;
		}
		
		//读取一个int来确认消息的长度，并使读取索引移动4位
		int dataLength = buffer.readIntLE();
		//协议号
		if (dataLength > size - 4) {
			//当流中的数据长度没有达到消息长度的要求时，说明该消息还没有被完全读取，
			//需要等流收集到足够的数据时才能继续处理
			//但上述的readInt时数组索引已经移动了4位，所以需要把读取索引重设回标记读取索引的位置
			buffer.resetReaderIndex();
			return;
		}
		int cmd = buffer.readIntLE();
		byte[] decoded = new byte[dataLength - 4];
		buffer.readBytes(decoded);
		//标记数组的读取索引
		buffer.markReaderIndex();
		
		GameMessage message = new GameMessage();
		message.setCmd(cmd);
		message.setMsg(decoded);
		
		//将读取到的完整消息添加到返回结果中，交由后续的处理器进行处理
		//另外由于ByteBuf并没有传递到后续的处理器中，因此后续的处理器并不需要关心ByteBuf的销毁问题
		out.add(message);
	}
}
