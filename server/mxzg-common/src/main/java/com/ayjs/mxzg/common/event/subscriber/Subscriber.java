package com.ayjs.mxzg.common.event.subscriber;

import lombok.extern.slf4j.Slf4j;

import java.lang.reflect.Method;
import java.util.Objects;
import java.util.concurrent.Executor;

/**
 * 订阅者
 */
@Slf4j
public class Subscriber {

    /**
     * 目标对象
     */
    private final Object target;
    /**
     * 处理方法
     */
    private final Method method;
    /**
     * 执行器
     */
    private final Executor executor;

    private Subscriber(Object target, Method method, Executor executor) {
        this.target = target;
        this.method = method;
        method.setAccessible(true);
        this.executor = executor;
    }

    public static Subscriber create(Object target, Method method, Executor executor) {
        return new Subscriber(target, method, executor);
    }

    public void dispatch(final Object event, long threshold) {
        executor.execute(() -> {
            long beforeTime = System.currentTimeMillis();
            try {
                method.invoke(target, event);
            } catch (IllegalArgumentException e) {
                throw new Error("Method rejected target/argument: " + event, e);
            } catch (IllegalAccessException e) {
                throw new Error("Method became inaccessible: " + event, e);
            } catch (Exception e) {
//                if (e.getCause() instanceof Error) {
//                    throw (Error) e.getCause();
//                }
                log.warn("Method {} ({})  on subscriber {} when dispatching event: {}", method.getName(),
                        method.getParameterTypes()[0].getName(), target, event);
                log.error("dispatch error:", e);
            } finally {
                long executeTime = System.currentTimeMillis() - beforeTime;
                if (threshold > 0 && executeTime > threshold && log.isWarnEnabled()) {
                    log.warn("Method {} ({})  on subscriber {} when dispatching event: {} execute {} ms",
                            method.getName(), method.getParameterTypes()[0].getName(), target, event, executeTime);
                }
            }
        });
    }

    @Override
    public int hashCode() {
        return Objects.hash(target, method);
    }

    @Override
    public final boolean equals(Object obj) {
        if (obj instanceof Subscriber) {
            Subscriber that = (Subscriber) obj;
            return target == that.target && method.equals(that.method);
        }
        return false;
    }

    @Override
    public String toString() {
        return String.format("target:%s method:%s executor:%s", target.getClass().getSimpleName(), method.getName(), executor.getClass().getSimpleName());
    }
}
