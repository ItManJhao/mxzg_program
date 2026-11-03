package com.ayjs.rpc.invoker;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.ReflectionUtil;
import com.ayjs.mxzg.common.util.TypeUtils;
import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Stream;

@Slf4j
@Component
public class InvokerHolder implements IRegister<MessageHandler> {

	/** 订阅者集合Table<messageType, List<invoker>> */
	private Map<Class<?>, MessageInvoker> messageInvokers = new HashMap<>();

	@Override
	public void registerBean(MessageHandler bean) {
		resolveMessageInvoker(bean);
	}

	/**
	 * 解析MessageInvoker对象
	 * 
	 * @param bean
	 */
	private void resolveMessageInvoker(MessageHandler bean) {
		Method[] methods = ReflectionUtil.getDeclaredMethodsWith(bean.getClass(), RemoteMethod.class);
		Stream.of(methods).forEach(method -> {
			Assert.isTrue(method.getParameterTypes().length >= 1, "被@Message标注的方法参数长度必须大于等于1");
			Class<?> type = method.getParameterTypes()[0];
            Assert.isTrue(TypeUtils.isAssignable(type, RemoteMessage.class), String.format("订阅消息%s的第一个参数类型不是RemoteMessage", type));
			messageInvokers.put(type, MessageInvoker.valueOf(bean, method));
		});
	}

	/**
	 * 根据消息类型获取
	 * 
	 * @param type
	 * @return
	 */
	public MessageInvoker getInvoker(Class<?> type) {
		MessageInvoker invoker = messageInvokers.get(type);
		Asserts.notNull(invoker, 0, ()-> String.format("消息{%s}找不到调用者", type.getName()));
		return invoker;
	}
}
