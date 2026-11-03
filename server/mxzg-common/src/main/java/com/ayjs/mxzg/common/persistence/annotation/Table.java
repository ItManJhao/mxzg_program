package com.ayjs.mxzg.common.persistence.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 表
 */
@Documented
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface Table {
    /**
     * 表名
     */
    String name();

    /**
     * 索引
     */
    Index[] indexes() default {};

    /**
     * 缓存
     */
    Cache[] cache() default {};

    /**
     * 注释说明
     */
    String comment() default "";

    /**
     * 编码
     */
    String charset() default "utf8mb4";

    /**
     * 分表策略
     */
    String clusterBy() default "";

    /**
     * 分表个数
     *
     * @return
     */
    int cluster() default 0;

    /**
     * 是否自动建表
     *
     * @return
     */
    boolean autoCreate() default true;

}
