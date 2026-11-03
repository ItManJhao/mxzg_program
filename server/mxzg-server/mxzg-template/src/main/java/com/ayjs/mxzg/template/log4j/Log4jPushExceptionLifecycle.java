package com.ayjs.mxzg.template.log4j;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.log.Log4jExceptionsPush;
import com.ayjs.mxzg.common.util.NamesThreadFactory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import java.util.Objects;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;

@Slf4j
@Component
@Configuration
public class Log4jPushExceptionLifecycle implements Lifecycle {

    @Value("${management.url:http}")
    private String managementUrl;
    @Value("${server.id}")
    private int serverId;

    private ScheduledExecutorService executor = null;

    private static String PUSH_EXCEPTION_URI = "/cli/RoleErrorLog/record";

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.LOW, Ordinal._7, "LOG4J_PUSH_EXCEPTION");
    }

    @Override
    public void start() throws Exception {

        if (Objects.isNull(managementUrl) || managementUrl.length() < 6) {
            log.info("management.url {} is error :", managementUrl);
            return;
        }
        executor = new ScheduledThreadPoolExecutor(1, new NamesThreadFactory("PUSH LOG4J EXCEPTION"));
        Log4jExceptionsPush log4jExceptionsPush = Log4jExceptionsPush.getInstance();
        log4jExceptionsPush.init(serverId, managementUrl + PUSH_EXCEPTION_URI, "com.ayjs", executor);
        log4jExceptionsPush.start();
    }

    @Override
    public void stop() throws Exception {
        if (Objects.nonNull(executor)) {
            executor.shutdown();
        }
    }
}
