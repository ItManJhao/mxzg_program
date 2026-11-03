package com.ayjs.mxzg.common.persistence.hook.invoker;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.TypeUtil;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class HookInvokerRegistry<T> implements IRegister<HookInvoker<T>> {

    private final Map<Class<T>, HookInvoker<T>> holder = new HashMap<>();

    @Override
    public void registerBean(HookInvoker<T> bean) {
        Class<T> clazz = resolveClass(bean);
        Asserts.isNull(holder.putIfAbsent(clazz, bean), String.format("%s duplicated", bean));
    }

    public HookInvoker<T> get(Class<T> clazz) {
        return holder.get(clazz);
    }

    @SuppressWarnings("unchecked")
    private Class<T> resolveClass(HookInvoker<T> bean) {
        return (Class<T>) TypeUtil.resolveClassArguments(bean.getClass(), HookInvoker.class)[0];
    }
}
