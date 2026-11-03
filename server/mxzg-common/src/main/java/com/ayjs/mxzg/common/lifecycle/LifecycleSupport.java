package com.ayjs.mxzg.common.lifecycle;

import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.Comparator;
import java.util.List;
import java.util.function.Consumer;
import java.util.stream.Collectors;

/**
 * 存活周期服务
 */
@Slf4j
public class LifecycleSupport {
    public static final Comparator<Lifecycle> LIFECYCLE_COMPARATOR =
            Comparator.comparingInt(lifecycle -> lifecycle.getInfo().getOrder());

    /**
     * 顺序启动服务
     */
//    public static void start(Collection<Lifecycle> services) {
//        services.stream().sorted(LIFECYCLE_COMPARATOR).forEach(LifecycleSupport::start);
//    }

    /**
     * 顺序启动服务
     */
    public static void start(Collection<Lifecycle> services, Consumer<Lifecycle> after) {
        int totalNumber = services.size();
        List<Lifecycle> collect = services.stream().sorted(LIFECYCLE_COMPARATOR).collect(Collectors.toList());
        int i = 1;
        for (Lifecycle lifecycle : collect) {
            log.debug("({}/{})  {}", i, totalNumber, lifecycle.getInfo().toString());
            i++;
        }
        i = 1;
        for (Lifecycle lifecycle : collect) {
            long startTime = System.currentTimeMillis();
            String name = lifecycle.getInfo().getName();
            log.info("({}/{})  [{}] service starting... {}", i, totalNumber, name, LocalDateTime.now());
            start(lifecycle);
            log.info("({}/{})  [{}] service started. {} use time:{}", i, totalNumber, name, LocalDateTime.now(),
                    (System.currentTimeMillis() - startTime));
            after.accept(lifecycle);
            i++;

        }
    }

    /**
     * 启动服务
     */
    public static void start(Lifecycle service) {
        try {
            service.start();
        } catch (Exception e) {
            log.info("[{}] service throw exception", service.getInfo().getName());
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /**
     * 逆序停止服务
     */
    public static void stop(Collection<Lifecycle> services) {
        int totalNumber = services.size();
        List<Lifecycle> collect = services.stream().sorted(LIFECYCLE_COMPARATOR.reversed()).collect(Collectors.toList());
        int i = 1;
        for (Lifecycle lifecycle : collect) {
            log.info("({}/{})  [{}] service stopping...", i, totalNumber, lifecycle.getInfo().getName());
            stop(lifecycle);
            log.info("({}/{})  [{}] service stopped.", i, totalNumber, lifecycle.getInfo().getName());
            i++;
        }
        services.stream().sorted(LIFECYCLE_COMPARATOR.reversed()).forEach(LifecycleSupport::stop);
    }

    /**
     * 停止服务
     */
    public static void stop(Lifecycle service) {
        try {
            service.stop();
        } catch (Exception e) {
            log.error("[{}] service throw exception.", service.getInfo().getName(), e);
        }
    }
}
