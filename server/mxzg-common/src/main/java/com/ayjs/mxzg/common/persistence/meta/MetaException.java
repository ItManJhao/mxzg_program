package com.ayjs.mxzg.common.persistence.meta;

/**
 * 数据存储实体异常
 */
public class MetaException extends RuntimeException {

    public MetaException() {
        super();
    }

    public MetaException(String message) {
        super(message);
    }

    public MetaException(Throwable t) {
        super(t);
    }
}
