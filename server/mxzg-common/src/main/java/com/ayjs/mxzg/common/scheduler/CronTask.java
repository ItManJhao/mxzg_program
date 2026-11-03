package com.ayjs.mxzg.common.scheduler;

import lombok.Value;

import java.time.LocalDateTime;

@Value
public class CronTask {

    private Object identity;
    private Runnable runnable;
    private CronTrigger trigger;
    private LocalDateTime lastScheduledExecutionTime;
    private LocalDateTime lastActualExecutionTime;
    private LocalDateTime lastCompletionTime;
    private TriggerContextListener listener;
}
