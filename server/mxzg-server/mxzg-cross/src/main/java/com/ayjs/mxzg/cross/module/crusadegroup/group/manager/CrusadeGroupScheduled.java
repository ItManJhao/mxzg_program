package com.ayjs.mxzg.cross.module.crusadegroup.group.manager;

import com.ayjs.mxzg.common.util.NamesThreadFactory;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;

/**
 * 调度器
 */
public class CrusadeGroupScheduled {

    /** 调度器 */
    private static ScheduledExecutorService executorService = Executors.newScheduledThreadPool(1,
            new NamesThreadFactory("CRUSADE_GROUP_SCHEDULED"));

    /**
     * 获取执行器服务器
     * @return
     */
    public static ScheduledExecutorService getExecutorService(){
        return executorService;
    }
}
