package com.ayjs.rpc.server;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

/**
 * 服务提供方
 *
 * Created by LeiJun on 2018/6/20.
 */
public class ServiceProvider {

    /** 服务提供方对象 */
    private final Object target;
    /** 服务提供方方法 */
    private final Method method;

    private ServiceProvider(Object target, Method method) {
        this.target = target;
        this.method = method;
        this.method.setAccessible(true);
    }

    public static ServiceProvider of(Object target, Method method) {
        return new ServiceProvider(target, method);
    }

    @Override
    public final int hashCode() {
        return (31 + method.hashCode()) * 31 + System.identityHashCode(target);
    }

    @Override
    public final boolean equals(Object obj) {
        if (obj instanceof ServiceProvider) {
            ServiceProvider that = (ServiceProvider) obj;
            return target == that.target && method.equals(that.method);
        }
        return false;
    }

    public Object provide(Object... args) throws IllegalAccessException, IllegalArgumentException, InvocationTargetException {
        return method.invoke(target, args);
    }

    public ServiceProviderContext context(Object[] args) {
        return ServiceProviderContext.of(target, method, args);
    }

    public Object getTarget() {
        return target;
    }

    public Method getMethod() {
        return method;
    }
}
