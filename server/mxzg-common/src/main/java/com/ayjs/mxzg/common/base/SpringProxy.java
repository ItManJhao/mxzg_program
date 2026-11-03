package com.ayjs.mxzg.common.base;

import com.google.common.base.Throwables;
import com.google.common.collect.ImmutableList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;
import org.springframework.util.ConcurrentReferenceHashMap;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * spring 工具
 */
@Component
public class SpringProxy implements ApplicationListener<ContextRefreshedEvent> {
    private static final Set<ContextListener> listeners = ConcurrentHashMap.newKeySet();
    private static final Map<Class<?>, List<Field>> autowiredFieldsCache = new ConcurrentReferenceHashMap<>(256);
    private static ApplicationContext applicationContext;

    /**
     * 获取需要注入的字段
     */
    private static List<Field> getAutowiredFields(Class<?> clazz) {
        return autowiredFieldsCache.computeIfAbsent(clazz, key -> loadAutowiredFields(clazz));
    }

    private static List<Field> loadAutowiredFields(Class<?> clazz) {
        List<Field> fields = resolveAnnotationField(clazz);
        fields.forEach(field -> field.setAccessible(true));
        return ImmutableList.copyOf(fields);
    }

    /**
     * 获取类所有的属性(包括从父类继承的, 但不包含Object.class)
     */
    private static <T extends Annotation> List<Field> resolveAnnotationField(Class<?> clazz) {
        if (clazz == null) {
            return Collections.emptyList();
        }

        List<Field> fields = new ArrayList<>();

        Class<?> searchType = clazz;
        while (!Object.class.equals(searchType)) {
            Arrays.asList(searchType.getDeclaredFields()).forEach(field -> {
                if (field.getAnnotation(Autowired.class) != null) {
                    fields.add(field);
                }
            });
            searchType = searchType.getSuperclass();
        }

        return fields;
    }

    /**
     * 注册spring上下文加载完成事件监听者，如果已经加载完成则立即回调
     */
    public static void register(ContextListener listener) {
        if (applicationContext != null) {
            listener.complete();
        } else {
            listeners.add(listener);
        }
    }

    /**
     * 自动注入bean
     */
    public static <T> T injectionBean(T bean) {
        try {
            List<Field> fields = getAutowiredFields(bean.getClass());
            for (Field field : fields) {
                Object value = getBean(field.getType());
                field.set(bean, value);
            }
            return bean;
        } catch (Exception e) {
            Throwables.throwIfUnchecked(e);
            throw new RuntimeException(e);
        }
    }

    public static Object getBean(String name) {
        return applicationContext.getBean(name);
    }

    public static <T> T getBean(Class<T> requiredType) {
        return applicationContext.getBean(requiredType);
    }

    public static <T> T getBean(String name, Class<T> requiredType) {
        return applicationContext.getBean(name, requiredType);
    }

    public static Collection<Object> getBeansWithAnnotation(Class<? extends Annotation> annotationType) {
        return applicationContext.getBeansWithAnnotation(annotationType).values();
    }

    public static <T> Collection<T> getBeansOfType(Class<T> type) {
        return applicationContext.getBeansOfType(type).values();
    }

    public static String[] getBeanDefinitionNames() {
        return applicationContext.getBeanDefinitionNames();
    }

    @Override
    public void onApplicationEvent(@NonNull ContextRefreshedEvent event) {
        applicationContext = event.getApplicationContext();
        listeners.forEach(ContextListener::complete);
        listeners.clear();
    }
}
