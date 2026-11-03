package com.ayjs.mxzg.common.event.subscriber;

import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.google.common.base.Throwables;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.ImmutableSet;
import com.google.common.reflect.TypeToken;
import com.google.common.util.concurrent.MoreExecutors;
import com.google.common.util.concurrent.UncheckedExecutionException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.util.Assert;

import java.lang.reflect.Method;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.Executor;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;

/**
 * 订阅者注册器
 */
@Slf4j
public final class SubscriberRegistry {

    private static final LoadingCache<Class<?>, ImmutableSet<Class<?>>> flattenHierarchyCache =
            CacheBuilder.newBuilder().weakKeys().build(new CacheLoader<Class<?>, ImmutableSet<Class<?>>>() {
                @Override
                public ImmutableSet<Class<?>> load(Class<?> concreteClass) {
                    return TypeToken.of(concreteClass).getTypes().rawTypes().stream().filter(clazz -> clazz != Object.class)
                            .collect(Collectors.collectingAndThen(Collectors.toSet(), ImmutableSet::copyOf));
                }
            });
    private final ConcurrentMap<Class<?>, CopyOnWriteArraySet<Subscriber>> subscriberMap = new ConcurrentHashMap<>();
    /**
     * 异步事件处理器
     */
    private final Executor executor;
    /**
     * 异步日志事件处理器
     */
    private final Executor logExecutor;

    public SubscriberRegistry(Executor executor, Executor logExecutor) {
        this.executor = executor;
        this.logExecutor = logExecutor;
    }

    private static ImmutableSet<Class<?>> flattenHierarchy(Class<?> concreteClass) {
        try {
            return flattenHierarchyCache.getUnchecked(concreteClass);
        } catch (UncheckedExecutionException e) {
            Throwables.throwIfUnchecked(e.getCause());
            throw new RuntimeException(e.getCause());
        }
    }

    public void register(Object observer) {
        Map<Class<?>, List<Subscriber>> observerMethods = findAllSubscribers(observer);
        observerMethods.forEach((event, methodInObserver) -> {
            subscriberMap.computeIfAbsent(event, key -> new CopyOnWriteArraySet<>()).addAll(methodInObserver);
        });
    }

    public void unregister(Object observer) {
        Map<Class<?>, List<Subscriber>> observerMethods = findAllSubscribers(observer);
        observerMethods.forEach((event, methodInObserver) -> {
            CopyOnWriteArraySet<Subscriber> currentSubscribers = subscriberMap.get(event);
            if (currentSubscribers != null) {
                currentSubscribers.removeAll(methodInObserver);
            }
        });
    }

    public Stream<Subscriber> streamSubscriber(Object event) {
        ImmutableSet<Class<?>> eventTypes = flattenHierarchy(event.getClass());
        return eventTypes.stream().map(subscriberMap::get).filter(Objects::nonNull).flatMap(Set::stream);
    }

    private Map<Class<?>, List<Subscriber>> findAllSubscribers(Object observer) {
        Map<Class<?>, List<Subscriber>> observerMethods = new HashMap<>();
        getAnnotatedMethods(observer.getClass()).forEach(method -> {
            Class<?> eventType = method.getParameterTypes()[0];
            Subscribe.AsyncType async = method.getAnnotation(Subscribe.class).async();
            Executor executor = null;
            if (AsyncType.Async == async) {
                executor = this.executor;
            } else if (Subscribe.AsyncType.AsyncLog == async) {
                executor = this.logExecutor;
            } else {
                executor = MoreExecutors.directExecutor();
            }

            Subscriber subscriber = Subscriber.create(observer, method, executor);
            observerMethods.computeIfAbsent(eventType, key -> new ArrayList<>()).add(subscriber);
        });
        return observerMethods;
    }

    private List<Method> getAnnotatedMethods(Class<?> clazz) {
        List<Method> methods = new ArrayList<>();
        Arrays.stream(clazz.getDeclaredMethods()).forEach(method -> {
            if (method.isAnnotationPresent(Subscribe.class) && !method.isSynthetic()) {
                Class<?>[] parameterTypes = method.getParameterTypes();
                Assert.isTrue(parameterTypes.length == 1, String.format(
                        "Method %s has @Subscribe annotation but has %s parameters."
                                + "Subscriber methods must have exactly 1 parameter.", method, parameterTypes.length));
                methods.add(method);
            }
        });
        return methods;
    }

    public void printSubscriberMap() {
        subscriberMap.keySet().stream().sorted(Comparator.comparing(name -> name.getSimpleName())).forEach(clazz -> {
            log.trace("class:{}", clazz.getName());
            CopyOnWriteArraySet<Subscriber> subscribers = subscriberMap.get(clazz);
            subscribers.stream().sorted(Comparator.comparing(subscriber -> subscriber.getClass().getSimpleName())).forEach(subscriber -> {
                log.trace("---subscriber:{}", subscriber.toString());
            });
        });
    }
}
