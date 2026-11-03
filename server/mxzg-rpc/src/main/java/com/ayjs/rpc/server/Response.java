package com.ayjs.rpc.server;

import com.ayjs.rpc.RpcMessage;

/**
 * 响应
 *
 * @author Alias
 * @date 2017年11月10日 下午1:54:25
 */
public class Response implements RpcMessage {

    private Object result;

    private Throwable exception;

    private long requestId;

    public Object getResult() {
        return result;
    }

    public void setResult(Object result) {
        this.result = result;
    }

    public Throwable getException() {
        return exception;
    }

    public void setException(Throwable exception) {
        this.exception = exception;
    }

    public long getRequestId() {
        return requestId;
    }

    public void setRequestId(long requestId) {
        this.requestId = requestId;
    }

    public boolean isError() {
        return exception != null;
    }

}
