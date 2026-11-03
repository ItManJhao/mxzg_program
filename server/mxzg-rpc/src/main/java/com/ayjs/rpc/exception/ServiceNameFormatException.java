package com.ayjs.rpc.exception;

/**
 * 服务名称格式异常
 *
 * @author Alias
 * @date 2017年12月11日 上午11:32:10
 */
public class ServiceNameFormatException extends RuntimeException {

    private static final long serialVersionUID = -4395138566365235489L;

    public ServiceNameFormatException() {
        super();
    }

    public ServiceNameFormatException(String message, Throwable cause, boolean enableSuppression,
                                      boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }

    public ServiceNameFormatException(String message, Throwable cause) {
        super(message, cause);
    }

    public ServiceNameFormatException(String message) {
        super(message);
    }

    public ServiceNameFormatException(Throwable cause) {
        super(cause);
    }
}
