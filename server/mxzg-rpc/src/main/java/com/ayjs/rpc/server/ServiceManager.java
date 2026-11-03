package com.ayjs.rpc.server;

import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

import com.ayjs.rpc.annotation.Remote;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.exception.DuplicateServiceException;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 服务管理器
 *
 * @author Alias
 * @date 2017年12月11日 下午1:48:59
 */
@Component
public class ServiceManager implements ApplicationListener<ContextRefreshedEvent> {

    /** 暴露给客户端的服务 */
    private final Map<String, Map<String, ServiceProvider>> services = new HashMap<>();

    public ServiceProvider getProvider(String className, String methodName) {
        Map<String, ServiceProvider> providers = services.get(className);
        return providers == null ? null : providers.get(methodName);
    }

    @Override
    public void onApplicationEvent(ContextRefreshedEvent event) {
        registerServices(event.getApplicationContext());
    }

    private void registerServices(ApplicationContext context) {
        context.getBeansWithAnnotation(Remote.class).forEach((k, service) -> register(service));
    }

    private void register(Object service) {
        String serviceName = service.getClass().getSimpleName();
        Map<String, ServiceProvider> providerMap = services.computeIfAbsent(serviceName, key -> new HashMap<>());
        List<ServiceProvider> providers = findAllServiceProviders(service);
        providers.forEach(provider -> {
            if (providerMap.putIfAbsent(provider.getMethod().getName(), provider) != null)
                throw new DuplicateServiceException("Duplicate service name:" + provider.getMethod().getName());
        });
    }

    private List<ServiceProvider> findAllServiceProviders(Object service) {
        List<Method> methods = getMethods(service.getClass());
        return methods.stream().map(method -> ServiceProvider.of(service, method)).collect(Collectors.toList());
    }

    private static List<Method> getMethods(Class<?> clazz) {
        List<Method> methods = new ArrayList<>();
        for (Method method : clazz.getDeclaredMethods()) {
            if (!method.isSynthetic() && Modifier.isPublic(method.getModifiers())
                    && method.getAnnotation(RemoteMethod.class) != null) {
                methods.add(method);
            }
        }
        return methods;
    }
}
