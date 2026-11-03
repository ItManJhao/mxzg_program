package com.ayjs.mxzg.template.eventbus;


import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.event.bus.EventBusImpl;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.NamesThreadFactory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.stream.Stream;

@Slf4j
@Configuration
public class EventBusLifecycle implements Lifecycle {
    /**
     * 异步事件处理器
     */
    private final ExecutorService executor;
    /**
     * 异步日志事件处理器
     */
    private final ExecutorService logExecutor;

    @Value("${eventbus.threshold:50}")
    private int eventBusThreshold;

    public EventBusLifecycle() {
        this.executor = Executors.newSingleThreadExecutor(new NamesThreadFactory("ASYNC EVENT BUS"));
        this.logExecutor = Executors.newSingleThreadExecutor(new NamesThreadFactory("ASYNC LOG EVENT BUS"));
    }

    @Bean
    EventBus eventBus() {
        return new EventBusImpl(executor, logExecutor, eventBusThreshold);
    }

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.SYSTEM, Ordinal._10, "EVENT BUS");
    }

    @Override
    public void start() throws Exception {
        EventBus eventBus = SpringProxy.getBean(EventBus.class);

        // 扫描全量类是否有事件监听
        String[] definitionNames = SpringProxy.getBeanDefinitionNames();
        Stream.of(definitionNames).forEach(beanNames -> {
            Object bean = SpringProxy.getBean(beanNames);
            eventBus.register(bean);
        });

//        SpringProxy.getBeansWithAnnotation(Observer.class).forEach(eventBus::register);

//        eventBus.printSubscriber();
    }

    @Override
    public void stop() throws Exception {
        executor.shutdown();

        log.info("发布缓存异步事件...");
        int count = 0;
        while (!executor.awaitTermination(5, TimeUnit.SECONDS)) {
            log.info("等待终止 {} 次", ++count);
        }
        log.info("发布缓存异步事件完毕");
    }
}
