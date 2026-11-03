package com.ayjs.mxzg.common.persistence.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 索引
 */
@Documented
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface Index {
    /**
     * 索引名
     */
    String name() default "";

    boolean unique() default false;

    /**
     * 索引包含的列
     */
    String[] columnList();

    /**
     * 索引类型
     */
    IndexType type() default IndexType.NORMAL;

    enum IndexType {
        /**
         * 普通索引
         */
        NORMAL,
        /**
         * 唯一索引
         */
        UNIQUE,//
        /**
         * 全文索引
         */
        FULLTEXT;
    }
}
