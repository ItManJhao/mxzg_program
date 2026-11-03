package com.ayjs.mxzg.tools.client.stresstest;

import io.netty.channel.ChannelInitializer;
import io.netty.channel.socket.SocketChannel;

/**
 * 压测程序通道
 *
 * @author tangyangbo 2019/8/30 20:43
 */
public class ClientPipelineFactory extends ChannelInitializer<SocketChannel> {
    @Override
    protected void initChannel(SocketChannel socketChannel) throws Exception {
//        ChannelPipeline pipeline = socketChannel.pipeline();
//        pipeline.addLast(new HttpClientCodec());
//        pipeline.addLast(new HttpObjectAggregator(65536));
//        pipeline.addLast(new ByteArrayDecoder());
//        pipeline.addLast(new ByteArrayEncoder());
//        WebSocketClientHandshaker handshaker = WebSocketClientHandshakerFactory.newHandshaker(
//                StressTesting.getServerUri(),
//                WebSocketVersion.V13,
//                null,
//                true,
//                new DefaultHttpHeaders());
//        //自定义的游戏协议处理器
//        pipeline.addLast("handler", new ClientStressTestHandler(handshaker));
    }
}