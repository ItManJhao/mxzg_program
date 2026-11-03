package com.ayjs.mxzg.common.executor;

import com.ayjs.mxzg.common.util.NamesThreadFactory;
import org.apache.commons.lang3.builder.HashCodeBuilder;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.TimeUnit;
import java.util.stream.IntStream;

/**
 * 有序执行器服务
 */
public class OrderlyExecutor implements OrderlyExecutorService {

    private final ExecutorService[] executors;

    public OrderlyExecutor(String name, int num) {
        if (num <= 0) {
            throw new IllegalArgumentException("num <= 0");
        }
        this.executors = new ExecutorService[num];
        String executorName = nullSafeGet(name);
        IntStream.range(0, num).forEach(i -> executors[i] = createExecutorService(createName(executorName, i + 1)));
    }

    private String nullSafeGet(String name) {
        return (name == null || name.trim().isEmpty()) ? "ORDERLY EXECUTOR" : name;
    }

    private ExecutorService createExecutorService(String name) {
        return Executors.newSingleThreadExecutor(new NamesThreadFactory(name));
    }

    private String createName(String name, int number) {
        return (name + "-" + number).toUpperCase();
    }

    @Override
    public ExecutorService hashOrRandom(Object key) {
        int index = key != null ? hashIndex(key) : ThreadLocalRandom.current().nextInt(executors.length);
        return executors[index];
    }

    private int hashIndex(Object key) {
        int hashCode = Math.abs(new HashCodeBuilder().append(key).toHashCode());
        return hashCode % executors.length;
    }

    @Override
    public void shutdown() {
        for (ExecutorService executor : executors) {
            executor.shutdown();
        }
    }

    @Override
    public boolean awaitTermination(long timeout, TimeUnit timeUnit) throws InterruptedException {
        for (ExecutorService executor : executors) {
            if (!executor.awaitTermination(timeout, timeUnit)) {
                return false;
            }
        }
        return true;
    }
}
