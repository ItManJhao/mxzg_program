package com.ayjs.mxzg.common.scheduler;

import com.ayjs.mxzg.common.util.NamesThreadFactory;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;

/**
 * 通用调度器
 */
public class CommonScheduledHolder {
    /**
     * 调度器
     */
    private static ScheduledExecutorService executorService = Executors.newScheduledThreadPool(1,
            new NamesThreadFactory("COMMON_SCHEDULED"));

    /**
     * 获取通用的调度器线程池服务
     *
     * @return
     */
    public static ScheduledExecutorService getScheduledExecutorService() {
        return executorService;
    }

}
