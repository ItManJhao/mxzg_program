/**
 * 
 */
package com.ayjs.mxzg.common.util;

import java.util.ArrayList;
import java.util.List;

/**
 * @author YY
 *
 */
public class PageUtil {
	
	/**
	 * 正序第N页
	 * @param list
	 * @param pageSize
	 * @param page 从1开始
	 * @return
	 */
	public static <T> List<T> pageN(List<T> list, int page, int pageSize) {
		int startIndex = (page - 1) * pageSize;
		int endIndex = page * pageSize;
		List<T> result = new ArrayList<>();
		for (int i = startIndex; i < endIndex && i < list.size(); i++) {
			result.add(list.get(i));
		}
		return result;
	}
	
	/**
	 * 倒序第N页
	 * @param list
	 * @param pageSize
	 * @param page
	 * @return
	 */
	public static <T> List<T> pageNDesc(List<T> list, int page, int pageSize) {
		int startIndex = (page - 1) * pageSize;
		int endIndex = page * pageSize;
		List<T> result = new ArrayList<>();
		for (int i = list.size() - 1 - startIndex; i >= 0
				&& i > list.size() - 1 - endIndex; i--) {
			result.add(list.get(i));
		}
		return result;
	}
}
