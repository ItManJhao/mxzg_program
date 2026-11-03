package com.ayjs.mxzg.common.persistence.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 列
 */
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface Column {
    /**
     * 列名
     */
    String name() default "";

    /**
     * 非空
     */
    boolean nullable() default true;

    /**
     * 待实现
     *
     * @return
     */
    boolean unique() default true;

    /**
     * 默认值
     */
    String defaultValue() default "";

    /**
     * 只读（更新时不更新该字段）
     */
    boolean readOnly() default false;

    /**
     * 字符串长度
     */
    int length() default 255;

    /**
     * 不可变长度
     */
    boolean immutable() default false;

    /**
     * 备注说明
     */
    String comment() default "";

    /**
     * 编码格式
     */
    String charset() default "";

    /**
     * 是否是长文本
     */
    boolean longtext() default false;
}
