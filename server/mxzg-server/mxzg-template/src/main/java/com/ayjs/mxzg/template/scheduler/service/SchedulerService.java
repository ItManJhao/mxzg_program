package com.ayjs.mxzg.template.scheduler.service;

import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.scheduler.CronTaskBuilder;
import com.ayjs.mxzg.common.scheduler.FixedDelayTask;
import com.ayjs.mxzg.common.scheduler.ICronTask;
import com.ayjs.mxzg.common.scheduler.ScheduledTaskRegistry;
import com.ayjs.mxzg.common.scheduler.TaskRejectedException;
import com.ayjs.mxzg.common.scheduler.ThreadPoolTaskScheduler;
import com.ayjs.mxzg.common.util.NamesThreadFactory;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;

/**
 * 定时服务
 */
@Slf4j
@Component
@Configuration
public class SchedulerService implements Lifecycle {

    @Value("${scheduler.threads:2}")
    private int schedulerThreads;

    @Value("${scheduler.threshold:200}")
    private int schedulerThreshold;

    private static final String EXECUTOR_NAME = "SCHEDULER";

    /**
     * 定时任务注册
     */
    private final ScheduledTaskRegistry registry;
    /**
     * 定时器
     */
    private final ThreadPoolTaskScheduler scheduler;
    /**
     * 回调
     */
    private final Set<Callback> callbacks;
    /**
     * 服务开启状态
     */
    private final AtomicBoolean status = new AtomicBoolean();

    private final Map<Long, ScheduledFuture<?>> futures = new ConcurrentHashMap<>();
    private final AtomicLong idGenerator = new AtomicLong();

    public SchedulerService() {
        if (schedulerThreads <= 0) {
            schedulerThreads = 2;
            log.debug("schedulerThreads is 0 ,set default value is :2");

        }
        if (schedulerThreshold <= 0) {
            schedulerThreshold = 200;
            log.debug("schedulerThreshold is 0 ,set default value is :200");
        }
        ScheduledExecutorService executor = new ScheduledThreadPoolExecutor(schedulerThreads, new NamesThreadFactory(EXECUTOR_NAME));
        this.scheduler = new ThreadPoolTaskScheduler(executor, schedulerThreshold);
        this.registry = new ScheduledTaskRegistry(scheduler);
        this.callbacks = ConcurrentHashMap.newKeySet();
    }

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._7, "SCHEDULER");
    }

    @Override
    public void start() throws Exception {
        status.compareAndSet(false, true);

        SpringProxy.getBeansOfType(ICronTask.class).forEach(task -> {
            task.initialize();
            registry.register(CronTaskBuilder.build(task));
        });

        registry.scheduleTasks();

        Iterator<Callback> iterator = callbacks.iterator();
        while (iterator.hasNext()) {
            Callback callback = iterator.next();
            callback.invoke();
            iterator.remove();
        }
    }

    @Override
    public void stop() throws Exception {
        status.compareAndSet(true, false);
        registry.cancelTasks();
        futures.forEach((k, future) -> future.cancel(false));
        scheduler.shutdown();
    }

    /**
     * 注册{@code FixedDelayTask},  服务开启时提交所有{@code FixedDelayTask}到定时器
     *
     * @param task
     */
    public void registerFixedDelayTask(FixedDelayTask task) {
        registry.register(task);
    }

    /**
     * 延时任务
     *
     * @param identity
     * @param command
     * @param delay
     * @param unit
     * @return
     */
    public ScheduledFuture<?> schedule(Object identity, Runnable command, long delay, TimeUnit unit) {
        if (!status.get()) {
            reject(identity, command);
        }
        long id = nextId();
        ScheduledFuture<?> future = scheduler.schedule(identity, () -> {
            try {
                command.run();
            } finally {
                futures.remove(id);
            }
        }, delay, unit);
        futures.put(id, future);
        return future;
    }

    private long nextId() {
        return idGenerator.incrementAndGet();
    }

    private void reject(Object identity, Runnable command) {
        throw new TaskRejectedException(String.format("Executor{%s} did not accept task{%s, %s}", EXECUTOR_NAME, identity, command));
    }

    /**
     * 注册回调,  服务开启时完成所有回调执行, 如果服务已开启, 则立即执行回调
     *
     * @param callback
     */
    public void register(Callback callback) {
        if (status.get()) {
            callback.invoke();
        } else {
            callbacks.add(callback);
        }
    }

    @FunctionalInterface
    public interface Callback {

        void invoke();
    }
}
