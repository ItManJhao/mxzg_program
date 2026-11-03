package com.ayjs.mxzg.common.scheduler;

import java.util.Objects;
import java.util.concurrent.ScheduledFuture;

public final class ScheduledTask {

    private final ScheduledFuture<?> future;

    public ScheduledTask(ScheduledFuture<?> future) {
        this.future = Objects.requireNonNull(future);
    }

    public void cancel() {
        future.cancel(false);
    }

}
