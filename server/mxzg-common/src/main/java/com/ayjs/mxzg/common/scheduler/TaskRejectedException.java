package com.ayjs.mxzg.common.scheduler;

import java.util.concurrent.RejectedExecutionException;

@SuppressWarnings("serial")
public class TaskRejectedException extends RejectedExecutionException {

    public TaskRejectedException(String msg) {
        super(msg);
    }

    public TaskRejectedException(String msg, Throwable cause) {
        super(msg, cause);
    }

}
