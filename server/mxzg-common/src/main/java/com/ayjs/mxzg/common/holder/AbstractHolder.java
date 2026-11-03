package com.ayjs.mxzg.common.holder;

import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.convert.ConvertUtils;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;



/**
 * 抽象的Bean Holder
 * @author meiyc
 *
 */
public abstract class AbstractHolder<K, T> implements Holder<K,T> ,IRegister<T>{

	/** 注册的bean列表 */
	protected final Map<K,T> beanMapping = new HashMap<>();
	
	@Override
	public void registerBean(T bean) {
		K key = convert(bean);
		if(key != null){
			T existence = beanMapping.put(key, bean);
			if(existence != null){
				throw new RuntimeException(String.format("%s注册对象重复key=%s，当前%s已经存在%s", getClass().getSimpleName(), key, bean.getClass().getSimpleName(),
						existence.getClass().getSimpleName()));
			}
		}
	}
	
	@Override
	public T get(K key) {
		return beanMapping.get(key);
	}
	
	@Override
	public T getOrThrow(K key) {
		T t = get(key);
		if(t == null){
			throw new RuntimeException(String.format("%s获取对象失败key=%s", getClass().getSimpleName(), key));
		}
		return t;
	}
	
	@Override
	public T getOfType(Class<?> type) {
		return getOfType_(type, type);
	}
	
	/**
	 * getOfType方法代理，避免丢失原始类型
	 * @param type
	 * @param primevalType
	 * @return
	 */
	private T getOfType_(Class<?> type, Class<?> primevalType) {
		T t = get(ConvertUtils.cast(type));
		if(t == null){
			Class<?> superClass = type.getSuperclass();
			if(superClass != null && superClass != Object.class){
				t = getOfType_(superClass, primevalType);
			}
		}
		
		if (t == null){
			Class<?>[] interfaces = type.getInterfaces();
            for (Class<?> interfaceType : interfaces) {
                t = getOfType_(interfaceType, primevalType);
				if(t != null)
					break;
			}
		}

		if(t == null && type == primevalType){
			throw new RuntimeException(String.format("%s找不到类型为%s的bean", getClass().getSimpleName(), primevalType));
		}
		return t;
	}
	
		
	@Override
	public Collection<T> values() {
		return beanMapping.values();
	}
	
	/**
	 * 转换为需要被存储的key
	 * @param bean
	 * @return
	 */
	protected abstract K convert(T bean);
}
