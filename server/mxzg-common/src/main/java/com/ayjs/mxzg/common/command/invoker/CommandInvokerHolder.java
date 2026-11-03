package com.ayjs.mxzg.common.command.invoker;

import java.lang.reflect.Method;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;
import org.springframework.util.Assert;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.command.Command;
import com.ayjs.mxzg.common.command.Receivers;
import com.ayjs.mxzg.common.command.annotation.Invoker;
import com.ayjs.mxzg.common.util.ReflectionUtil;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;

@Component
public class CommandInvokerHolder implements IRegister<Receivers>{

	/** Map<CommandType, List<CommandInvoker> */
	private final Multimap<Class<?>, CommandInvoker> invokers = ArrayListMultimap.create();
	
	/** 指令对应的接受者列表 */
	private final LoadingCache<Class<?>, List<CommandInvoker>> commandReceivers = CacheBuilder.newBuilder()
			.build(new CacheLoader<Class<?>, List<CommandInvoker>>() {
		public List<CommandInvoker> load(Class<?> eventType) {
			return getCommandInvokers(eventType);
		}
	});
	
	@Override
	public void registerBean(Receivers bean) {
		invokers.putAll(findAllSubscribers(bean));
	}
	
	/**
	 * 根据commandType获取一组Invoker
	 * @param commandType
	 * @return
	 */
	public List<CommandInvoker> get(Class<?> commandType){
		return  commandReceivers.getUnchecked(commandType);
	}

	/**
	 * 查找所有的订阅者
	 * @param invokers
	 * @return
	 */
	private <T extends Command> Multimap<Class<T>, CommandInvoker> findAllSubscribers(Object invokers) {
		Multimap<Class<T>, CommandInvoker> methodsInListener = ArrayListMultimap.create();
		Method[] methods = ReflectionUtil.getDeclaredMethodsWith(invokers.getClass(), Invoker.class);
		for (Method method : methods) {
			Class<T> commandType = resolveCommandType(method);
			methodsInListener.put(commandType, CommandInvoker.create(invokers, method));
		}
		return methodsInListener;
	}
	
	/**
	 * 根据指令类型获取指令调用列表
	 * @param commandType
	 * @return
	 */
	private List<CommandInvoker> getCommandInvokers(Class<?> commandType){
		Set<Class<?>> commandTypes = ReflectionUtil.getSupperClass(commandType);
		return commandTypes.stream().flatMap(type -> invokers.get(type).stream().sorted()).collect(Collectors.toList());
	}

	/**
	 * 解析commandType类型
	 * @param method
	 * @return
	 */
	@SuppressWarnings("unchecked") private <T extends Command> Class<T> resolveCommandType(Method method) {
		Invoker receiver = method.getAnnotation(Invoker.class);
		if (receiver.commandType() == Command.class) {
			Assert.isTrue(method.getParameterTypes().length == 1, "指令参数调用的参数数量必须等于1");
			return (Class<T>) method.getParameterTypes()[0];
		}
		return (Class<T>) receiver.commandType();
	}
	
}
