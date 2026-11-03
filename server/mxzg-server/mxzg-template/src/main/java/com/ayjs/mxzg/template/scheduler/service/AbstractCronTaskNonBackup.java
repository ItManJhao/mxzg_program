package com.ayjs.mxzg.template.scheduler.service;


import com.ayjs.mxzg.common.scheduler.ICronTask;

import java.time.LocalDateTime;

/**
 *
 */
public abstract class AbstractCronTaskNonBackup implements ICronTask {

    @Override
    public final LocalDateTime lastScheduledExecutionTime() {
        return null;
    }

    @Override
    public final LocalDateTime lastActualExecutionTime() {
        return null;
    }

    @Override
    public final LocalDateTime lastCompletionTime() {
        return null;
    }
}
