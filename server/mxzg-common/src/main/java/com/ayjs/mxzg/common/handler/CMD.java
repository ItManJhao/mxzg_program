/**
 * 
 */
package com.ayjs.mxzg.common.handler;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @author YY
 * CMD注解只会被用于函数上，用以标明该函数将作为协议处理函数被调动
 */
@Documented
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface CMD {
	/**
	 * 协议号
	 * @return
	 */
	public int id();
	/**
	 * 是否需要登录才能调用
	 * @return
	 */
	public boolean needLogin() default true;
	/**
	 * 协议的准入条件
	 * @return
	 */
	public String entry() default "";
}
