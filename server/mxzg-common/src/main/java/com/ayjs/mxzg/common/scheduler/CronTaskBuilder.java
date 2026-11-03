package com.ayjs.mxzg.common.scheduler;

public class CronTaskBuilder {

    public static CronTask build(ICronTask task) {
        return new CronTask(task.identity(),
                task,
                new CronTrigger(task.expression()),
                task.lastScheduledExecutionTime(),
                task.lastActualExecutionTime(),
                task.lastCompletionTime(),
                task);
    }
}
