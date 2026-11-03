package com.ayjs.rpc.client;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * @author Alias
 * @date 2017年12月12日 下午4:02:02
 */
@SuppressWarnings("rawtypes")
@Component
public class MessageHandlerManager {

    @Autowired(required = false)
    private Set<MessageHandler> handlers = new HashSet<>();

    private final Map<Class<?>, MessageHandler> lookups = new HashMap<>();

    @PostConstruct
    private void registerHandlers() {
        for (MessageHandler<?> handler : handlers) {
            Type type = handler.getClass().getGenericInterfaces()[0];
            Type[] p = ((ParameterizedType) type).getActualTypeArguments();
            Class<?> clazz = (Class<?>) p[0];
            lookups.put(clazz, handler);
        }
    }

    public MessageHandler getHandler(Class<?> key) {
        return lookups.get(key);
    }
}
