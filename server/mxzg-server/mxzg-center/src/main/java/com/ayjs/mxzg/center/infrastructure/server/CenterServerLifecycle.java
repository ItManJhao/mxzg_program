package com.ayjs.mxzg.center.infrastructure.server;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.rpc.server.RpcServer;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class CenterServerLifecycle implements Lifecycle {


    @Value("${network.tcpSocket.port:11122}")
    private int port;

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.LOW, 0, "CROSS_SERVER");
    }

    @Override
    public void start() throws Exception {
        RpcServer server = new RpcServer(port);
        server.start();
        log.info("中心服启动绑定端口{}", port);
    }

}
