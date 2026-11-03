package com.ayjs.mxzg.gameserver.remote.large;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class LargeServerLifecycle implements Lifecycle {

    @Autowired
    private LargeServerClient largeServerClient;

    @Value("${large.server.host}")
    private String host;
    @Value("${large.server.port}")
    private int port;


    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("LARGE_SERVER");
    }

    @Override
    public void start() throws Exception {
        largeServerClient.start(host, port);
    }

    @Override
    public void stop() throws Exception {
        largeServerClient.shutdown();
    }
}
