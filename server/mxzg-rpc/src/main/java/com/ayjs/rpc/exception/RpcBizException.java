package com.ayjs.rpc.exception;

/**
 * @author Alias
 * @date 2018年1月5日 上午9:38:26
 */
public class RpcBizException extends RuntimeException {

    private static final long serialVersionUID = 1598749270495627866L;

    private Throwable exception;

    public RpcBizException(Throwable exception) {
        super();
        this.exception = exception;
    }

    public Throwable getException() {
        return exception;
    }
}
