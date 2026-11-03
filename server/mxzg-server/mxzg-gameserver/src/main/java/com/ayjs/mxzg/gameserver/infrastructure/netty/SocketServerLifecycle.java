package com.ayjs.mxzg.gameserver.infrastructure.netty;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.netty.LittleEndianChannelInitializer;
import com.ayjs.mxzg.common.netty.NettySocketServer;
import com.ayjs.mxzg.common.netty.websocket.WebSocketServerInitializer;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import io.netty.handler.ssl.SslContext;
import io.netty.handler.ssl.SslContextBuilder;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.net.ssl.KeyManagerFactory;
import java.io.FileInputStream;
import java.security.KeyStore;

/**
 * 网络服务
 */
@Slf4j
@Component
public class SocketServerLifecycle implements Lifecycle {
    private final NettySocketServer nettySocketServer;
    @Autowired
    private ServerConfig serverConfig;

    @Autowired
    public SocketServerLifecycle(ServerConfig serverConfig) {
        int bossThreads = 2;
        int workThreads = serverConfig.getNetworkTcpSocketThreads();
        nettySocketServer = new NettySocketServer(bossThreads, workThreads);
    }

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.LOW, Ordinal._50, "SOCKET_SERVER");
    }

    @Override
    public void start() throws Exception {

        NettyHandler nettyHandler = new NettyHandler();
        nettySocketServer.startServer(serverConfig.getNetworkTcpSocketPort(),
                new LittleEndianChannelInitializer(nettyHandler, serverConfig.getNetworkTcpSocketIdle()));

        // 配置了websocket端口就启动
        if (serverConfig.getNetworkWebSocketPort() > 0) {
            SslContext sslContext = null;
            // 是否启用SSL
            if (StringUtils.isNotBlank(serverConfig.getSslFile()) && StringUtils.isNotBlank(serverConfig.getSslPassword())) {
                KeyManagerFactory keyManagerFactory = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
                KeyStore keyStore = KeyStore.getInstance("JKS");
                char[] sslPasswordChar = serverConfig.getSslPassword().toCharArray();
                keyStore.load(new FileInputStream(serverConfig.getSslFile()), sslPasswordChar);
                keyManagerFactory.init(keyStore, sslPasswordChar);
                sslContext = SslContextBuilder.forServer(keyManagerFactory).build();
                log.info("open ssl file:{}", serverConfig.getSslFile());
            }
            nettySocketServer.startServer(serverConfig.getNetworkWebSocketPort(),
                    new WebSocketServerInitializer(sslContext, serverConfig.getNetworkTcpSocketIdle(), nettyHandler));
        }

    }

    @Override
    public void stop() throws Exception {
        nettySocketServer.shutdown();
    }
}
