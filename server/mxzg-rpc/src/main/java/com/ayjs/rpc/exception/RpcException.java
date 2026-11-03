package com.ayjs.rpc.exception;

/**
 * RPC异常
 *
 * @author Alias
 * @date 2017年12月11日 下午5:32:53
 */
public class RpcException extends RuntimeException {

    private static final long serialVersionUID = -6368074804264472310L;

    private Exception exception;

    public RpcException(Exception exception) {
        this.exception = exception;
    }

    public Exception getException() {
        return exception;
    }
}
