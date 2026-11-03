package com.ayjs.rpc.client;

import com.ayjs.rpc.exception.RpcTimeoutException;
import com.ayjs.rpc.server.Response;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * @author Alias
 * @date 2018年1月10日 下午4:18:28
 */
@Slf4j
public class ResponseFuture<T> implements Future<T> {

    private static final int NORMAL = 0;
    private static final int COMPLETED = 1;
    private static final int CANCELLED = 2;
    /** 默认超时时间 */
    private static final int TIME_OUT = 1000;

    protected Request request;
    private Lock lock = new ReentrantLock();
    private Condition condition = lock.newCondition();
    private T result;
    private Throwable exception;
    // 请求时间
    private long timestamp = System.currentTimeMillis();
    private int timeout;
    private List<FutureListener<T>> listeners;
    private volatile int state = NORMAL;

    public ResponseFuture(Request request) {
        this.request = request;
    }

    @SuppressWarnings("unchecked")
    public void onSuccess(Response response) {
        this.result = (T) response.getResult();
        done();
    }

    public void onFailure(Response response) {
        this.exception = response.getException();
        done();
    }

    @Override
    public T get() {
        lock.lock();
        try {
            while (isNormal()) {
                try {
                    condition.await();
                } catch (InterruptedException e) {
                    log.error(e.getMessage(), e);
                }
            }
            return result;
        } finally {
            lock.unlock();
        }
    }

    @Override
    public Throwable cause() {
        return exception;
    }

    @Override
    public boolean cancel() {
        return cancel(new RpcTimeoutException(request.getMessage().getClass() + " already be a timeout, cost time:" + (System.currentTimeMillis() - timestamp)));
    }

    protected boolean cancel(Exception e) {
        lock.lock();
        try {
            if (!isNormal()) {
                return false;
            }
            state = CANCELLED;
            exception = e;
            condition.signalAll();
        } finally {
            lock.unlock();
        }
        notifyListeners();
        return true;
    }

    @Override
    public boolean isCancelled() {
        return state == CANCELLED;
    }

    @Override
    public boolean isDone() {
        return state == COMPLETED;
    }

    @Override
    public boolean isSuccess() {
        return isDone() && (exception == null);
    }

    @Override
    public void addListener(FutureListener<T> listener) {
        if (listener == null) {
            throw new NullPointerException("FutureListener is null");
        }
        lock.lock();
        try {
            if (listeners == null) {
                listeners = new ArrayList<>(1);
            }
            listeners.add(listener);
            if (!isNormal()) {
                notifyListener(listener);
            }
        } finally {
            lock.unlock();
        }
    }

    private void notifyListeners() {
        if (listeners != null) {
            for (FutureListener<T> listener : listeners) {
                notifyListener(listener);
            }
        }
    }

    private void notifyListener(FutureListener<T> listener) {
        try {
            listener.operationComplete(this);
        } catch (Exception e) {
            log.error(e.getMessage(), e);
        }
    }

    private boolean isNormal() {
        return state == NORMAL;
    }

    protected boolean done() {
        lock.lock();
        try {
            if (!isNormal()) {
                return false;
            }
            state = COMPLETED;
            condition.signalAll();
        } finally {
            lock.unlock();
        }
        notifyListeners();
        return true;
    }

    public long requestId() {
        return this.request.getRequestId();
    }

    /**
     * 请求是否超时
     *
     * @return
     */
    public boolean isTimeout() {
        long now = System.currentTimeMillis();
        if (timeout == 0) {
            return now - timestamp >= TIME_OUT;
        }
        return now - timestamp >= timeout;
    }

    public void setTimeout(int timeout) {
        this.timeout = timeout;
    }
}
