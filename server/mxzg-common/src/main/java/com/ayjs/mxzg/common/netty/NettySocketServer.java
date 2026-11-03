/**
 * 
 */
package com.ayjs.mxzg.common.netty;

import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelOption;
import io.netty.channel.EventLoopGroup;
import io.netty.channel.WriteBufferWaterMark;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.util.concurrent.DefaultThreadFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author YY
 * ch.pipeline().addLast(new NettyHandler());
 */
public class NettySocketServer {
	
	private static Logger logger = LoggerFactory.getLogger(NettySocketServer.class);

	private final EventLoopGroup bossGroup;

	private final EventLoopGroup workerGroup;

	public NettySocketServer(int bossThreads, int workThreads){
		//Netty的管理线程池，用于为各个连接分配工作线程
		bossGroup = new NioEventLoopGroup(bossThreads, new DefaultThreadFactory("bossGroup"));
		//Netty的工作线程池，用于处理各个线程的通信
		workerGroup = new NioEventLoopGroup(workThreads,
				new DefaultThreadFactory("workerGroup"));
	}

	/**
	 * 启动服务器
	 */
	public void startServer(int port, ChannelInitializer channelInitializer) {
		ServerBootstrap bootstrap = new ServerBootstrap();
		bootstrap.option(ChannelOption.SO_REUSEADDR, true);
		bootstrap.childOption(ChannelOption.TCP_NODELAY, true);
        bootstrap.childOption(ChannelOption.WRITE_BUFFER_WATER_MARK, new WriteBufferWaterMark(32768, 192 * 1024));
		bootstrap.group(bossGroup, workerGroup)
				.channel(NioServerSocketChannel.class)
				.childHandler(channelInitializer);
		try {
			// 绑定通信端口
			bootstrap.bind(port).sync();
			logger.info("Netty server start on port: " + port);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 关闭服务
	 */
	public void shutdown(){
		try {
			bossGroup.shutdownGracefully().sync();
		} catch (InterruptedException e) {
			logger.error("shutdown boss group failed", e);
		}
		try {
			workerGroup.shutdownGracefully().sync();
		} catch (InterruptedException e) {
			logger.error("shutdown worker group failed", e);
		}
	}
	
}
