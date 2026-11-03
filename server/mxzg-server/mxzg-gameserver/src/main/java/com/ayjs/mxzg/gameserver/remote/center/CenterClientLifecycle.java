package com.ayjs.mxzg.gameserver.remote.center;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Priority;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * 启动连接中心服
 *
 * @author meiyc
 */
@Component
public class CenterClientLifecycle  implements Lifecycle {

    @Value("${center.server.host}")
    private String host;
    @Value("${center.server.port}")
    private int port;
    @Autowired
    private CenterClient centerClient;

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.LOW, 0, "CENTER_SERVER");
    }

    @Override
    public void start() throws Exception {
        centerClient.start(host, port);
    }

    @Override
    public void stop() throws Exception {
        centerClient.shutdown();
    }
}
