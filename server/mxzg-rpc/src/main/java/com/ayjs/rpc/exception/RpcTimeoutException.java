package com.ayjs.rpc.exception;

/**
 * 超时
 *
 * @author Alias
 * @date 2018年1月10日 下午4:43:36
 */
public class RpcTimeoutException extends RuntimeException {

    private static final long serialVersionUID = -8599176005360445809L;

    public RpcTimeoutException() {
        super();
    }

    public RpcTimeoutException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }

    public RpcTimeoutException(String message, Throwable cause) {
        super(message, cause);
    }

    public RpcTimeoutException(String message) {
        super(message);
    }

    public RpcTimeoutException(Throwable cause) {
        super(cause);
    }
}
