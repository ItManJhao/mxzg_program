package com.ayjs.mxzg.common.holder;

/**
 * 将bean的Class作为key的持有者
 * @author meiyc
 *
 */
public abstract class AbstractTypeHolder<T> extends AbstractHolder<Class<?>, T>{

	
	@Override
	protected Class<?> convert(T bean) {
		return bean.getClass();
	}
}
