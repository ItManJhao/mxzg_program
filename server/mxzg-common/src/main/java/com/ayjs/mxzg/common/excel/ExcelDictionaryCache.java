/**
 * 
 */
package com.ayjs.mxzg.common.excel;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author YY
 *
 */
public abstract class ExcelDictionaryCache {
	
	protected Logger logger = LoggerFactory.getLogger(ExcelDictionaryCache.class);
	
	private static List<ExcelDictionaryCache> dictionarys = new ArrayList<>();
	
	public ExcelDictionaryCache() {
		dictionarys.add(this);
	}
	
	public final void loadDictionary(Map<String, ? extends IDictionaryStruct> map) {
		//只自动加载int、long、String类型
		Field[] fields = this.getClass().getFields();
		for(Field field : fields) {
			ExcelDictionaryField dictionary = field.getAnnotation(ExcelDictionaryField.class);
			if(dictionary == null || !map.containsKey(dictionary.value())) {
				continue;
			}
			Class<?> type = field.getType();
			Object value = null;
			if (type == Integer.TYPE || type == Integer.class) {
				value = parseInt(map, dictionary.value());
            } else if (type == Long.TYPE || type == Long.class) {
            	value = parseLong(map, dictionary.value());
            } else if (type == String.class) {
            	value = parseString(map, dictionary.value());
            } else {
				value = ConvertUtils.convertTo(map.get(dictionary.value()).getValue(), field.getGenericType());
            }
			try {
				field.set(null, value);
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			}
		}
		//加载独特的字典常量
		loadSpecialDictionary(map);
		
//		printFieldValue();
	}
	
	protected void printFieldValue() {
		Field[] fields = this.getClass().getFields();
		for(Field field : fields) {
			try {
				logger.info(field.getName() + " " + field.get(null));
			} catch (IllegalArgumentException e) {
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				e.printStackTrace();
			}
		}
	}
	
	protected void loadSpecialDictionary(Map<String, ? extends IDictionaryStruct> map) {
		//子类自己实现
	}
	
	protected final int parseInt(Map<String, ? extends IDictionaryStruct> map, String key) {
		try {
			return Integer.parseInt(map.get(key).getValue());
		} catch (Exception e) {
			logger.error("参数{}解释错误，无法转化为int", key);
		}
		return 0;
	}
	
	protected final long parseLong(Map<String, ? extends IDictionaryStruct> map, String key) {
		try {
			return Long.parseLong(map.get(key).getValue());
		} catch (Exception e) {
			logger.error("参数{}解释错误，无法转化为long", key);
		}
		return 0;
	}
	
	protected final String parseString(Map<String, ? extends IDictionaryStruct> map, String key) {
		try {
			return map.get(key).getValue();
		} catch (Exception e) {
			logger.error("参数{}解释错误，无法转化为String", key);
		}
		return "";
	}
	
	public static interface IDictionaryStruct {
		public String getKey();
		public String getValue();
	}
	
	public static void load(Map<String, ? extends IDictionaryStruct> map) {
		for(ExcelDictionaryCache dictionary : dictionarys) {
			dictionary.loadDictionary(map);
		}
	}
}
