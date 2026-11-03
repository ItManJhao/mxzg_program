package com.ayjs.mxzg.cross.web.support;

/**
 * web.api异常处理
 */
public class WebErrorCodeException extends RuntimeException {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/**
     * 错误码
     **/
    private final int errorCode;

    public WebErrorCodeException(String message, int errorCode) {
        super(message);
        this.errorCode = errorCode;
    }

    public WebErrorCodeException(int errorCode) {
        this.errorCode = errorCode;
    }

    /**
     * 重写父类fillInStackTrace方法，删除synchronized、删除堆栈信息。
     */
    @Override
    public Throwable fillInStackTrace() {
        return this;
    }

    public int getErrorCode() {
        return errorCode;
    }
}
