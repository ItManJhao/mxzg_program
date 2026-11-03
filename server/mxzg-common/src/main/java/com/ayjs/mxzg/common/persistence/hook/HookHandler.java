package com.ayjs.mxzg.common.persistence.hook;

import com.ayjs.mxzg.common.persistence.hook.invoker.HookInvoker;
import com.ayjs.mxzg.common.persistence.hook.invoker.HookInvokerRegistry;
import com.google.common.reflect.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@Component
public class HookHandler<T> {

    @Autowired
    private HookInvokerRegistry<T> invokerRegistry;

    private final ConcurrentMap<Class<T>, Map<HookOpportunity, List<HookInvoker<T>>>> invokers = new ConcurrentHashMap<>();

    private List<HookInvoker<T>> getInvokers(Class<T> clazz, HookOpportunity opportunity) {
        return invokers.computeIfAbsent(clazz, this::resolveInvokers).getOrDefault(opportunity, Collections.emptyList());
    }

    private Map<HookOpportunity, List<HookInvoker<T>>> resolveInvokers(Class<T> clazz) {
        Map<HookOpportunity, List<HookInvoker<T>>> map = new HashMap<>();
        Set<Class<? super T>> interfaces = TypeToken.of(clazz).getTypes().interfaces().rawTypes();
        for (Class<? super T> _interface : interfaces) {
            Hook hook = _interface.getAnnotation(Hook.class);
            if (hook != null) {
                @SuppressWarnings("unchecked")
                HookInvoker<T> invoker = invokerRegistry.get((Class<T>) _interface);
                map.computeIfAbsent(hook.opportunity(), key -> new ArrayList<>()).add(invoker);
            }
        }
        return map;
    }

    /**
     * 勾一下并返回 {@code entity} 是否有修改
     *
     * @param entity
     * @param opportunity
     * @return
     */
    public boolean hookIt(T entity, HookOpportunity opportunity) {
        boolean update = false;
        @SuppressWarnings("unchecked")
        List<HookInvoker<T>> invokers = getInvokers((Class<T>) entity.getClass(), opportunity);
        for (HookInvoker<T> invoker : invokers) {
            if (invoker.invoke(entity)) {
                update = true;
            }
        }
        return update;
    }
}
