package com.ayjs.mxzg.common.command.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.ayjs.mxzg.common.command.Command;



/**
 * 标记为一个接收者
 * @author meiyc
 *
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(value = ElementType.METHOD)
@Documented
public @interface Invoker {
	
	/**
	 * 指令类型
	 * @return
	 */
	Class<? extends Command> commandType() default Command.class;

	/** 
	 * 优先级从高到低执行 
	 */
	Priority value() default Priority.MEDIUM;
	
	
	/**
	 * 命令调用的优先级
	 */
	public static enum Priority {

		/** 优先级-高 */
		HIGHEST,
		
		/** 优先级-中 */
		MEDIUM,
		
		/** 优先级-低 */
		LOWEST
	}
}
