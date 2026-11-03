package com.ayjs.mxzg.common.event.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 事件订阅者
 */
@Documented
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface Subscribe {

    /**
     * 异步类型
     */
    AsyncType async() default AsyncType.Sync;

    /**
     * 异步类型
     */
    enum AsyncType {
        /**
         * 同步
         */
        Sync,
        /**
         * 异步业务
         */
        Async,
        /**
         * 异步日志业务
         */
        AsyncLog;
    }
}
