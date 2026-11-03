package com.ayjs.mxzg.common.base;

import com.google.common.reflect.TypeToken;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;

import java.util.Collection;

/**
 * Bean注册
 */
@SuppressWarnings({"rawtypes", "unchecked"})
@Component
public class BeanRegister implements ApplicationListener<ContextRefreshedEvent> {

    @Override
    public void onApplicationEvent(@NonNull ContextRefreshedEvent event) {
        ApplicationContext context = event.getApplicationContext();
        Collection<IRegister> beanRegistries = context.getBeansOfType(IRegister.class).values();
        beanRegistries.forEach(registry -> register(registry, context));
    }

    private <T> void register(IRegister<T> registry, ApplicationContext context) {
        Class<T> registerClass = resolveRegisterClass(registry);
        Collection<T> beans = context.getBeansOfType(registerClass).values();
        beans.forEach(registry::registerBean);
    }

    private <T> Class<T> resolveRegisterClass(IRegister<T> registry) {
        return (Class<T>) TypeToken.of(registry.getClass()).resolveType(IRegister.class.getTypeParameters()[0]).getRawType();
    }
}
