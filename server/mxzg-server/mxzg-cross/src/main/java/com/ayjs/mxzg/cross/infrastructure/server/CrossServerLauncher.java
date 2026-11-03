package com.ayjs.mxzg.cross.infrastructure.server;

import com.ayjs.rpc.server.RpcServer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class CrossServerLauncher {

    @Value("${network.tcpSocket.port:11122}")
    private int port;

    /**
     * 是否启动
     */
    private volatile boolean starting = false;

    /**
     * 启动跨服
     *
     * @throws Exception
     */
    public synchronized void start() {
        if (starting) {
            log.info("服务器已经启动...");
            return;
        }

        RpcServer server = new RpcServer(port);
        server.start();
        log.info("跨服启动绑定端口{}", port);
        this.starting = true;
    }

}
