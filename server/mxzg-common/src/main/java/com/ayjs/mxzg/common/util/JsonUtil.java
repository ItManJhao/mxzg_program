/**
 * 
 */
package com.ayjs.mxzg.common.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.TypeReference;

/**
 * @author YY
 * 适用于fastjson-1.2.35版本及以上
 */
public class JsonUtil {

	/**
	 * 通过json获取list
	 * 
	 * @param json
	 * @param clazz
	 * @return
	 */
	public static <T> List<T> getList(String json, Class<T> clazz) {
		List<T> list = JSONObject.parseArray(json, clazz);
		if (list == null) {
			list = new ArrayList<>();
		}
		return list;
	}

	/**
	 * 通过json获取非线程安全的map
	 * 
	 * @param json
	 * @param keyClazz
	 * @param valueClazz
	 * @return
	 */
	public static <K, V> Map<K, V> getMap(String json, Class<K> keyClazz, Class<V> valueClazz) {
		Map<K, V> map = JSONObject.parseObject(json, new TypeReference<Map<K, V>>(keyClazz, valueClazz) {});
		if(map == null) {
			map = new HashMap<>();
		}
		return map;
	}

	/**
	 * 通过json获取线程安全的map
	 * 
	 * @param json
	 * @param keyClazz
	 * @param valueClazz
	 * @return
	 */
	public static <K, V> ConcurrentMap<K, V> getConcurrentMap(String json, Class<K> keyClazz, Class<V> valueClazz) {
		ConcurrentMap<K, V> map = JSONObject.parseObject(json,
				new TypeReference<ConcurrentMap<K, V>>(keyClazz, valueClazz) {
				});
		if (map == null) {
			map = new ConcurrentHashMap<>();
		}
		return map;
	}

	/**
	 * 将对象转换成json字符串
	 * 
	 * @param object
	 * @return
	 */
	public static String toJson(Object object) {
		return JSONObject.toJSONString(object);
	}

	/**
	 * 通过json字符串解释对象
	 * 
	 * @param json
	 * @param clazz
	 * @return
	 */
	public static <T> T parseJson(String json, Class<T> clazz) {
		T t = JSONObject.parseObject(json, clazz);
		if(t == null) {
			try {
				t = clazz.newInstance();
			} catch (InstantiationException e) {
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			}
		}
		return t;
	}


}
