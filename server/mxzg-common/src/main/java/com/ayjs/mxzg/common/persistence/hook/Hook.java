package com.ayjs.mxzg.common.persistence.hook;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 标记一个接口为钩子接口
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Hook {

    /**
     * 钩子需要被勾的时机
     *
     * @return
     */
    HookOpportunity opportunity();
}
