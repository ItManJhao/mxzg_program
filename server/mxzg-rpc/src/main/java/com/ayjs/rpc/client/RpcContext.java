package com.ayjs.rpc.client;

import com.ayjs.rpc.server.Response;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.concurrent.*;

/**
 * @author Alias
 * @date 2017年11月17日 上午9:57:07
 */
@Slf4j
@Component
public class RpcContext<T> {

    /** 监控请求是否超时 */
    private final ScheduledExecutorService executor = Executors.newSingleThreadScheduledExecutor();

    private final ConcurrentMap<Long, ResponseFuture<T>> callbacks = new ConcurrentHashMap<>();

    @PostConstruct
    private void start() {
        executor.scheduleAtFixedRate(new TimeoutMonitor(), 0, 2000, TimeUnit.MILLISECONDS);
    }

    /**
     * 增加callback函数
     *
     * @param future
     */
    public void addCallback(ResponseFuture<T> future) {
        callbacks.put(future.requestId(), future);
    }

    public void invoke(Response response) {
        ResponseFuture<T> future = callbacks.remove(response.getRequestId());
        if (future == null) {
            log.error("No such request:" + response.getRequestId());
            return;
        }
        if (response.isError()) {
            future.onFailure(response);
            return;
        }
        future.onSuccess(response);
    }

    /**
     * 超时监控任务
     *
     * @author Alias
     * @date 2017年12月15日 下午5:34:07
     */
    class TimeoutMonitor implements Runnable {

        @Override
        public void run() {
            callbacks.forEach((k, v) -> {
                if (v.isTimeout()) {
                    Future<T> future = callbacks.remove(v.requestId());
                    future.cancel();
                }
            });
        }
    }
}
