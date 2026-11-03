/**
 * 
 */
package com.ayjs.mxzg.common.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

/**
 * @author YY
 *
 */
public class ListMapUtil {

	public static <K, T> Map<K, T> listToMap(List<T> list, Function<T, K> f) {
		Map<K, T> map = new HashMap<>();
		for(T t : list) {
			K keyValue = f.apply(t);
			map.put(keyValue, t);
		}
		return map;
	}
	
	
	
	public static <T, K1, K2> Map<K1, Map<K2, T>> fillTwoLayerMap(List<T> list, Function<T, K1> k1, Function<T, K2> k2) {
		Map<K1, Map<K2, T>> map = new HashMap<>();
		for (T t : list) {
			K1 firstValue = k1.apply(t);
			K2 secondValue = k2.apply(t);

			Map<K2, T> subMap = map.get(firstValue);
			if (subMap == null) {
				subMap = new HashMap<>();
				map.put(firstValue, subMap);
			}
			subMap.put(secondValue, t);
		}
		return map;
	}
	
	
	public static <T, K> Map<K, List<T>> fillListMap(List<T> tlist, Function<T, K> f) {
		Map<K, List<T>> map = new HashMap<>();
		for(T t : tlist) {
			K keyValue = f.apply(t);
			List<T> list = map.get(keyValue);
			if(list == null) {
				list = new ArrayList<>();
				map.put(keyValue, list);
			}
			list.add(t);
		}
		return map;
	}
	
}
