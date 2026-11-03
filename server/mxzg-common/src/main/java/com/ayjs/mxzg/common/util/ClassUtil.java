/**
 * 
 */
package com.ayjs.mxzg.common.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author YY
 *
 */
public class ClassUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(ClassUtil.class);
	
	public static String upperFirstFieldLetter(String fieldName) {
		return fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1);
	}
	
	public static String getterName(String fieldName) {
		return "get" + upperFirstFieldLetter(fieldName);
	}
	
	public static String setterName(String fieldName) {
		return "set" + upperFirstFieldLetter(fieldName);
	}
	/**
	 * 输出调用栈链
	 * @return
	 */
	public static RuntimeException printStackTrace() {
		return printStackTrace("");
	}
	public static RuntimeException printStackTrace(String info) {
		RuntimeException exception = new RuntimeException(info);
		StackTraceElement[] elements = exception.getStackTrace();
		for(StackTraceElement element : elements) {
			logger.info(element.toString());
		}
		return exception;
	}
}
