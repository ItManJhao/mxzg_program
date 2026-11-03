package com.ayjs.mxzg.common.scheduler;

@FunctionalInterface
public interface ErrorHandler {

    /**
     * Handle the given error, possibly rethrowing it as a fatal exception.
     */
    void handleError(Throwable t);
}
