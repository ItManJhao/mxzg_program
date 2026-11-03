  package com.ayjs.rpc.exception;

/**
 * 重复注册服务异常
 *
 * @author Alias
 * @date 2017年12月11日 下午8:46:21
 */
@SuppressWarnings("serial")
public class DuplicateServiceException extends RuntimeException {

    public DuplicateServiceException(String message) {
        super(message);
    }
}
