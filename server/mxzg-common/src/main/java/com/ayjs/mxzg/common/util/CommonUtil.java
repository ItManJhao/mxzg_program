package com.ayjs.mxzg.common.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Collection;

/**
 * 
 * 类名称：CommonUtils 类描述：常用工具类 创建人：yxh 创建时间：2012-7-16 上午07:43:40 修改备注：
 * 
 * @version 1.0.0
 * 
 */
public class CommonUtil {

	private static final Logger logger = LoggerFactory
			.getLogger(CommonUtil.class);

	/**
	 * 判断一个集合是否为空或没有元素
	 * 
	 */
	public static <T> boolean isCollectionEmpty(Collection<T> collection) {
		if (collection == null || collection.isEmpty()) {
			return true;
		}
		return false;
	}

	/**
	 * 字符串是否为空
	 *
	 * @param str
	 * @return
	 */
	public static boolean isNull(String str) {
		return str == null || str.length() == 0 || str.equals(" ")
				|| str.equals("null") || str.trim().length() == 0;
	}
}
