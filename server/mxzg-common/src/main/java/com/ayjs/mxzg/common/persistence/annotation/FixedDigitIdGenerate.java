package com.ayjs.mxzg.common.persistence.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 固定数字长度ID规则
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
@Documented
public @interface FixedDigitIdGenerate {
    /**
     * 初始值
     *
     * @return
     */
    int initialValue() default 1;

    /**
     * 位数
     *
     * @return
     */
    int digit() default 6;
}
