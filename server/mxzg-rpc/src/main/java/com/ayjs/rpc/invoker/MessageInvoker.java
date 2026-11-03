package com.ayjs.rpc.invoker;

import cn.hutool.core.lang.Assert;
import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.reflect.MethodInvoker;
import com.ayjs.mxzg.common.util.Nonnull;
import com.ayjs.rpc.DefaultResultMessage;
import com.ayjs.rpc.ErrorCodeMessage;
import com.ayjs.rpc.PlayerMessage;
import com.ayjs.rpc.RemoteMessage;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.reflect.TypeUtils;

import java.lang.reflect.Method;
import java.util.stream.Stream;

/**
 * message调用者
 * 
 * @author meiyc
 *
 */
@Slf4j
public class MessageInvoker{

	private final Class<?>[] types;
	private final Class<?> returnType;
	private final MethodInvoker methodInvoker;

	private MessageInvoker(Object handler, Method method) {
		this.methodInvoker = MethodInvoker.create(handler, method);
		this.types = method.getParameterTypes();
		this.returnType = method.getReturnType();
        if (this.returnType != void.class) {
            Assert.isAssignable(RemoteMessage.class, this.returnType);
        }
	}

	public static MessageInvoker valueOf(Object handler, Method method) {
		return new MessageInvoker(handler, method);
	}


    public RemoteMessage invoke(RemoteMessage message, Connection session) {
		Object callbackMessage = null;
		try {
			callbackMessage = methodInvoker.invoke(getArgs(message, session));
		} catch(ErrorCodeException ex){
			if(message instanceof PlayerMessage){
				PlayerMessage msg = (PlayerMessage)message;
				callbackMessage = ErrorCodeMessage.of(msg.getRid(), ex.getErrorCode(), ex.getParams());
			} else {
				log.error("消息{}处理抛出错误码必须实现PlayerMessage消息才能被返回,错误：{}",message.getClass(), ex.getMessage());
				ex.printStackTrace();
			}
		} catch(Throwable ex){
			log.error(String.format("消息处理失败message:%s", message.getClass()), ex);
			ex.printStackTrace();
		} finally {
			if(returnType != void.class){
				callbackMessage = Nonnull.or(callbackMessage, ()-> DefaultResultMessage.of(returnType));
			}
		}
		return (RemoteMessage)callbackMessage;
	}

    private Object[] getArgs(RemoteMessage message, Connection session) {
        return Stream.of(types).map(type -> getArgOfType(type, message, session)).toArray();
    }

    private Object getArgOfType(Class<?> type, RemoteMessage message, Connection session) {
		if (TypeUtils.isAssignable(type, message.getClass())) {
			return message;
        } else if (com.ayjs.mxzg.common.util.TypeUtils.isAssignable(type, Connection.class)) {
            return session;
        }
		throw new RuntimeException(String.format("不支持的参数类型%s", type));
	}

}
