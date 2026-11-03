package com.ayjs.mxzg.common.scheduler;

import java.time.LocalDateTime;

public interface TriggerContextListener {

    default void onDetermineNextExecutionTime(LocalDateTime nextExecutionTime) {
    }

    default void onUpdate(LocalDateTime lastScheduledExecutionTime, LocalDateTime lastActualExecutionTime, LocalDateTime lastCompletionTime) {
    }
}
