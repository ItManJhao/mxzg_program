package com.ayjs.mxzg.common.holder;

import java.util.Collection;

public interface Holder<K,T> {

	/**
	 * 根据key获取
	 * @param key
	 * @return
	 */
	T get(K key);
	
	/**
	 * 根据ke获取bean 如果bean为null则抛出异常
	 * @param key
	 * @return
	 */
	T getOrThrow(K key);
	
	/**
	 * 根据类型获取bean 注：当key为class时该方法才有用，取值顺序当前类>父类>接口类
	 * @param type
	 * @return
	 */
	T getOfType(Class<?> type);
	
	/**
	 * 值集合
	 * @return
	 */
	Collection<T> values(); 
}
