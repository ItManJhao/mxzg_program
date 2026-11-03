package com.ayjs.rpc.util;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

@Component
public class InstanceFactory implements ApplicationListener<ContextRefreshedEvent> {

    private static ApplicationContext context;

    public static void setApplicationContext(ApplicationContext ac) {
        context = ac;
    }

    public static <T> T getInstance(Class<T> clazz) {
        return (T) context.getBean(clazz);
    }

    @SuppressWarnings("unchecked")
    public static <T> T getInstance(String name) {
        return (T) context.getBean(name);
    }

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        context = event.getApplicationContext();
    }

}
