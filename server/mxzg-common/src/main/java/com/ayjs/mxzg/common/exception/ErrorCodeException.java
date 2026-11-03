package com.ayjs.mxzg.common.exception;

import lombok.Getter;

/**
 * 带错误码的异常信息
 */
public class ErrorCodeException extends RuntimeException {

    private static final long serialVersionUID = -3273816394533321441L;

    /**
     * 错误编号
     */
    @Getter
    private final int errorCode;
    /**
     * 参数，错误语音需要填充的参数
     */
    @Getter
    private final String[] params;

	public ErrorCodeException(int errorCode, String message, String... params) {
		super(message);
		this.errorCode = errorCode;
		this.params = params;
	}
}
