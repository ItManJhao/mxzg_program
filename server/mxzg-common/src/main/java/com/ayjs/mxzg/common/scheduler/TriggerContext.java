package com.ayjs.mxzg.common.scheduler;

import java.time.LocalDateTime;

public class TriggerContext {

    private volatile LocalDateTime lastScheduledExecutionTime;
    private volatile LocalDateTime lastActualExecutionTime;
    private volatile LocalDateTime lastCompletionTime;

    public TriggerContext(LocalDateTime lastScheduledExecutionTime, LocalDateTime lastActualExecutionTime, LocalDateTime lastCompletionTime) {
        this.lastScheduledExecutionTime = lastScheduledExecutionTime;
        this.lastActualExecutionTime = lastActualExecutionTime;
        this.lastCompletionTime = lastCompletionTime;
    }

    /**
     * Update this holder's state with the latest time values.
     *
     * @param lastScheduledExecutionTime last <i>scheduled</i> execution time
     * @param lastActualExecutionTime    last <i>actual</i> execution time
     * @param lastCompletionTime         last completion time
     */
    public void update(LocalDateTime lastScheduledExecutionTime, LocalDateTime lastActualExecutionTime, LocalDateTime lastCompletionTime) {
        this.lastScheduledExecutionTime = lastScheduledExecutionTime;
        this.lastActualExecutionTime = lastActualExecutionTime;
        this.lastCompletionTime = lastCompletionTime;
    }

    public LocalDateTime lastScheduledExecutionTime() {
        return lastScheduledExecutionTime;
    }

    public LocalDateTime lastActualExecutionTime() {
        return lastActualExecutionTime;
    }

    public LocalDateTime lastCompletionTime() {
        return lastCompletionTime;
    }
}
