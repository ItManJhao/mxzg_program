/**
 * 
 */
package com.ayjs.mxzg.common.handler;

import java.lang.reflect.Method;

import com.google.protobuf.Message;

/**
 * @author YY
 *
 */
public class HandlerExecutor {
	/**
	 * 协议ID
	 */
	private int id;
	/**
	 * 是否需要登录才能调用
	 */
	private boolean needLogin;
	/**
	 * 调用方法的实例，即对应函数所在类的实例
	 */
	private Object invoker;
	/**
	 * 协议处理函数
	 */
	private Method method;
	/**
	 * 协议类
	 */
	private Message message;
	/**
	 * 协议的准入条件
	 */
	private String entry;
	
	protected HandlerExecutor(CMD cmd, Object invoker, Method method) throws Exception {
		this.id = cmd.id();
		this.needLogin = cmd.needLogin();
		this.invoker = invoker;
		this.method = method;
		Class<?> clazz = method.getParameterTypes()[1];
		Method insMethod = clazz.getDeclaredMethod("getDefaultInstance");
		this.message = (Message)insMethod.invoke(null);
		this.entry = cmd.entry();
	}
	//get...
	
	public int getId() {
		return id;
	}
	public boolean isNeedLogin() {
		return needLogin;
	}
	public Object getInvoker() {
		return invoker;
	}
	public Method getMethod() {
		return method;
	}
	public Message getMessage() {
		return message;
	}
	public String getEntry() {
		return entry;
	}
}
