package com.ayjs.mxzg.common.command.invoker;

import java.lang.reflect.Method;

import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.common.reflect.MethodInvoker;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class CommandInvoker implements Comparable<CommandInvoker>{
	
	/** 排序值 */
	private final int order;
	/** 方法调用者 */
	private final MethodInvoker methodInvoker;

	public static CommandInvoker create(Object target, Method method){
		int order = method.getAnnotation(Invoker.class).value().ordinal();
		MethodInvoker methodInvoker = MethodInvoker.create(target, method);
		CommandInvoker invokerInfo = new CommandInvoker(order, methodInvoker);
		return invokerInfo;
	}

	/**
	 * 指令调用
	 * @param command
	 */
	public void invoke(final Object command) {
		methodInvoker.invoke(command);
	}
	
	/**
	 * 指令调用
	 * @param args
	 */
	public Object invoke(final Object... args){
		return methodInvoker.invoke(args);
	}

	@Override
	public int compareTo(CommandInvoker o) {
		return Integer.compare(order, o.getOrder());
	}
	
}
