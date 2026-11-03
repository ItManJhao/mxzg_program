package com.ayjs.mxzg.common.reflect;

import java.lang.reflect.Method;

import com.esotericsoftware.reflectasm.MethodAccess;

import lombok.AllArgsConstructor;

/**
 * 方法调用者对象
 * @author meiyc
 *
 */
@AllArgsConstructor
public class MethodInvoker {

	/** 方法调用者 */
	private final MethodAccess invoker;
	/** 指定对象 */
	private final Object target;
	/** 方法下标 */
	private final int methodIndex;
	
	public static MethodInvoker create(Object target, Method method){
		MethodAccess methodAccess = MethodAccess.get(target.getClass());
		int methodIndex = methodAccess.getIndex(method.getName(), method.getParameterTypes());
		MethodInvoker methodInvoker = new MethodInvoker(methodAccess, target, methodIndex);
		return methodInvoker;
	}
	
	/**
	 * 方法调用
	 * @param args
	 * @return
	 */
	public Object invoke(Object... args){
		return invoker.invoke(target, methodIndex, args);
	}
	
}
