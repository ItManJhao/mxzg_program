package com.ayjs.mxzg.common.scheduler;

import java.time.LocalDateTime;

public interface ICronTask extends Runnable, TriggerContextListener {

    /**
     * initialize task
     */
    default void initialize() {
    }

    /**
     * task identity
     *
     * @return
     */
    Object identity();

    /**
     * a space-separated list of time fields
     *
     * @return
     */
    String expression();

    /**
     * last <i>scheduled</i> execution time of the task
     *
     * @return
     */
    LocalDateTime lastScheduledExecutionTime();

    /**
     * last <i>actual</i> execution time of the task
     *
     * @return
     */
    LocalDateTime lastActualExecutionTime();

    /**
     * last completion time of the task
     *
     * @return
     */
    LocalDateTime lastCompletionTime();
}
