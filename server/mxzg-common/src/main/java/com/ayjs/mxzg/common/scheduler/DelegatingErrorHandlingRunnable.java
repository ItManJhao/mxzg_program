package com.ayjs.mxzg.common.scheduler;

import java.lang.reflect.UndeclaredThrowableException;
import java.util.Objects;

public class DelegatingErrorHandlingRunnable implements Runnable {

    private final Runnable delegate;

    private final ErrorHandler errorHandler;

    /**
     * Create a new DelegatingErrorHandlingRunnable.
     *
     * @param delegate     the Runnable implementation to delegate to
     * @param errorHandler the ErrorHandler for handling any exceptions
     */
    public DelegatingErrorHandlingRunnable(Runnable delegate, ErrorHandler errorHandler) {
        Objects.requireNonNull(delegate, "Delegate must not be null");
        Objects.requireNonNull(errorHandler, "ErrorHandler must not be null");
        this.delegate = delegate;
        this.errorHandler = errorHandler;
    }

    @Override
    public void run() {
        try {
            this.delegate.run();
        } catch (UndeclaredThrowableException ex) {
            this.errorHandler.handleError(ex.getUndeclaredThrowable());
        } catch (Throwable ex) {
            this.errorHandler.handleError(ex);
        }
    }

    @Override
    public String toString() {
        return "DelegatingErrorHandlingRunnable for " + this.delegate;
    }
}
