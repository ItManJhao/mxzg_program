package com.ayjs.mxzg.common.holder;

import com.ayjs.mxzg.common.util.TypeUtils;

/**
 * 将泛型参数类型作为key的bean持有者
 * @author meiyc
 *
 */
public abstract class AbstractArgumentTypeHolder<T> extends AbstractHolder<Class<?>, T>{

	@Override
	protected Class<?> convert(T bean) {
		Class<?> superClass = TypeUtils.resolveClassArguments(getClass(), AbstractHolder.class)[1];
		return TypeUtils.resolveClassArguments(bean.getClass(), superClass)[0];
	}
}
