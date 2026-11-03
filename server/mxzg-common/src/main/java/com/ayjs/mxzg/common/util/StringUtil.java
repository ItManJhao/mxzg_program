package com.ayjs.mxzg.common.util;

import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * string工具
 * 
 * @author chao
 * 
 */
public class StringUtil {

	/**
	 * 分割符"_"
	 */
	public static final String DELIMITER_INNER_ITEM = "_";
	/**
	 * 分割符","
	 */
	private static final String REGEX_DOU_HAO = "\\,";
	/**
	 * 分割符","
	 */
	public static final String DELIMITER_BETWEEN_ITEMS = ",";

	/**
	 * 把数组Object[]组装成以_分割的字符串
	 * 
	 * @param obj
	 * @return
	 */
	public static String arrayToString(Object[] objs) {
		StringBuilder bf = null;
		if (objs != null && objs.length > 0) {
			for (Object obj : objs) {
				if (obj != null && !obj.equals("")) {
					if (bf == null) {
						bf = new StringBuilder();
					} else {
						bf.append(DELIMITER_INNER_ITEM);
					}
					bf.append(obj);
				}
			}
		}
		return bf == null ? null : bf.toString();
	}

	/**
	 * 把数组Object组装成以_分割的字符串
	 * 
	 * @param obj
	 * @return
	 */
	public static String objectToString(Object... objs) {
		StringBuilder bf = null;
		for (Object obj : objs) {
			if (obj != null && !obj.equals("")) {
				if (bf == null) {
					bf = new StringBuilder();
				} else {
					bf.append(DELIMITER_INNER_ITEM);
				}
				bf.append(obj);
			}
		}
		return bf == null ? null : bf.toString();
	}

	/**
	 * 把数组Object[]组装成以指定分割的字符串
	 * 
	 * @param obj
	 * @param regex
	 * @return
	 */
	public static String arrayToString(Object[] objs, String regex) {
		StringBuilder bf = null;
		if (objs != null && objs.length > 0) {
			for (Object obj : objs) {
				if (obj != null && !obj.equals("")) {
					if (bf == null) {
						bf = new StringBuilder();
					} else {
						bf.append(regex);
					}
					bf.append(obj);
				}
			}
		}
		return bf == null ? null : bf.toString();
	}

	/**
	 * 把List<T>组装成以指定分割的字符串 T为Long、Integer、String时使用
	 * 
	 * @param obj
	 * @param regex
	 * @return
	 */
	public static <T> String listToString(List<T> list, String regex) {
		if (CommonUtil.isCollectionEmpty(list)) {
			return null;
		}
		StringBuilder bf = null;
		for (T value : list) {
			if (bf == null) {
				bf = new StringBuilder();
			} else {
				bf.append(regex);
			}
			bf.append(value);
		}
		return bf == null ? null : bf.toString();
	}

	/**
	 * 将list解释成a_b_c,d_e_f格式
	 * 
	 * @param <T>
	 * @param list
	 * @return
	 */
	public static <T> String listArrayToString(List<T[]> list) {
		return listArrayToString(list, ",", "_");
	}

	/**
	 * 把List<T[]>组装成以指定分割的字符串
	 * 
	 * @param obj
	 * @param itemsRegex
	 *            项与项之间的分割符,例如上面的|
	 * @param valueRegex
	 *            项值之间的分割符,例如上面的_
	 * @return
	 */
	public static <T> String listArrayToString(List<T[]> list,
			String itemsRegex, String valueRegex) {
		if (CommonUtil.isCollectionEmpty(list)) {
			return null;
		}
		StringBuilder bf = null;
		for (T[] valueArray : list) {
			if (bf == null) {
				bf = new StringBuilder();
			} else {
				bf.append(itemsRegex);
			}
			int i = 0;
			for (T value : valueArray) {
				if (i > 0) {
					bf.append(valueRegex);
				}
				i++;
				bf.append(value);
			}
		}
		return bf == null ? null : bf.toString();
	}

	/**
	 * 把以_分割的字符串分解成数组
	 * 
	 * @param str
	 * @return
	 */
	public static <T> T[] stringToArray(String str, Class<T> clz) {
		return stringToArray(str, DELIMITER_INNER_ITEM, clz);
	}

	/**
	 * 把以1_2_3,4_5_6分割的字符串分解成List<T[]>
	 * 
	 * @param str
	 * @return
	 */
	public static <T> List<T[]> stringToListArray(String str, Class<T> clz) {
		return stringToListArray(str, clz, REGEX_DOU_HAO, DELIMITER_INNER_ITEM);
	}

	/**
	 * 把类似字符串a_b_c|e_f_g分割成List<T[]>
	 * 
	 * @param <T>
	 * @param str
	 * @param clz
	 *            最终值的类型
	 * @param itemsRegex
	 *            项与项之间的分割符,例如上面的|
	 * @param valueRegex
	 *            项值之间的分割符,例如上面的_
	 * @return 没有数据返回空元素的集合
	 */
	public static <T> List<T[]> stringToListArray(String str, Class<T> clz,
			String itemsRegex, String valueRegex) {
		if (CommonUtil.isNull(str)) {
			return new ArrayList<T[]>();
		}
		String[] arr = split(str, itemsRegex);
		List<T[]> result = new ArrayList<T[]>(arr.length);
		for (String value : arr) {
			result.add((T[]) stringToArray(value, valueRegex, clz));
		}
		return result;
	}

	/**
	 * 把类似字符串a|b|c分割成List<T>
	 * 
	 * @param <T>
	 * @param str
	 * @param clz
	 *            最终值的类型
	 * @param itemsRegex
	 *            项与项之间的分割符,例如上面的|
	 * @return 没有数据返回空元素的集合
	 */
	public static <T> List<T> stringToList(String str, String itemsRegex,
			Class<T> clz) {
		if (CommonUtil.isNull(str)) {
			return new ArrayList<T>();
		}
		String[] arr = split(str, itemsRegex);
		List<T> result = new ArrayList<T>(arr.length);
		for (String value : arr) {
			result.add(getValueByStr(value, clz));
		}
		return result;
	}

	/**
	 * 把以regex分割的字符串分解成数组
	 * 
	 * @param str
	 * @return
	 */
	public static <T> T[] stringToArray(String str, String regex, Class<T> cls) {
		if (str == null || str.length() == 0) {
			return null;
		}
		String[] arr = split(str, regex);
		return stringToArray(arr, cls, 0);
	}

	/**
	 * 把以regex分割的字符串分解成数组
	 * 
	 * @param str
	 * @return
	 */
	@SuppressWarnings("unchecked")
	private static <T> T[] stringToArray(String[] scrValueArray, Class<T> cls,
			int startIndex) {
		if (scrValueArray == null || scrValueArray.length == 0) {
			return null;
		}
		int j = 0;
		if (cls == Integer.class) {
			Integer[] result = new Integer[scrValueArray.length - startIndex];
			for (int i = startIndex; i < scrValueArray.length; i++) {
				result[j] = Integer.parseInt(scrValueArray[i]);
				j++;
			}
			return (T[]) result;
		} else if (cls == Float.class) {
			Float[] result = new Float[scrValueArray.length - startIndex];
			for (int i = startIndex; i < scrValueArray.length; i++) {
				result[j] = Float.parseFloat(scrValueArray[i]);
				j++;
			}
			return (T[]) result;
		} else if (cls == Long.class) {
			Long[] result = new Long[scrValueArray.length - startIndex];
			for (int i = startIndex; i < scrValueArray.length; i++) {
				result[j] = Long.parseLong(scrValueArray[i]);
				j++;
			}
			return (T[]) result;
		} else if (cls == String.class) {
			if (startIndex == 0) {
				return (T[]) scrValueArray;
			} else {
				String[] result = new String[scrValueArray.length - startIndex];
                System.arraycopy(scrValueArray, startIndex, result, 0, result.length);
//				for (int i = startIndex; i < scrValueArray.length; i++) {
//					result[j] = scrValueArray[i];
//					j++;
//				}
			}
		}
		return null;
	}

	/**
	 * 把以1_2|1_3类似格式的字符串分解成HashMap<K,V>
	 * 
	 * @param str
	 * @param itemsRegex
	 *            项与项之间的分割符,例如上面的|
	 * @param valueRegex
	 *            项值之间的分割符,例如上面的_
	 * 
	 * @param keyClz
	 *            key类型
	 * @param valueClz
	 *            value类型
	 * @return 没有数据返回空元素的集合
	 */
	public static <K, V> Map<K, V> stringToMap(String str, String itemsRegex,
			String valueRegex, Class<K> keyClz, Class<V> valueClz) {
		if (CommonUtil.isNull(str)) {
			return new HashMap<K, V>();
		}
		String[] arr = split(str, itemsRegex);
		Map<K, V> map = new HashMap<K, V>(arr.length);
		for (String s : arr) {
			String[] subArr = split(s, valueRegex);
			map.put(getValueByStr(subArr[0], keyClz),
					getValueByStr(subArr[1], valueClz));
		}
		return map;
	}
	
	public static <K, V> Map<K, V> stringToConcurrentMap(String str, String itemsRegex,
			String valueRegex, Class<K> keyClz, Class<V> valueClz) {
		if (CommonUtil.isNull(str)) {
			return new ConcurrentHashMap<K, V>();
		}
		String[] arr = split(str, itemsRegex);
		Map<K, V> map = new ConcurrentHashMap<K, V>(arr.length);
		for (String s : arr) {
			String[] subArr = split(s, valueRegex);
			map.put(getValueByStr(subArr[0], keyClz),
					getValueByStr(subArr[1], valueClz));
		}
		return map;
	}

	/**
	 * 把以1_2|1_3类似格式的字符串分解成HashMap<K,V>
	 * 
	 * @param str
	 * @param itemsRegex
	 *            项与项之间的分割符,例如上面的|
	 * @param valueRegex
	 *            项值之间的分割符,例如上面的_
	 * 
	 * @param keyClz
	 *            key类型
	 * @param valueClz
	 *            value类型
	 * @return 没有数据返回空元素的集合
	 */
	public static <K, V> LinkedHashMap<K, V> stringToLinkedMap(String str,
			String itemsRegex, String valueRegex, Class<K> keyClz,
			Class<V> valueClz) {
		if (CommonUtil.isNull(str)) {
			return new LinkedHashMap<K, V>();
		}
		String[] arr = split(str, itemsRegex);
		LinkedHashMap<K, V> map = new LinkedHashMap<K, V>(arr.length);
		for (String s : arr) {
			String[] subArr = split(s, valueRegex);
			if (subArr.length == 2) {
				map.put(getValueByStr(subArr[0], keyClz),
						getValueByStr(subArr[1], valueClz));
			}
		}
		return map;
	}

	/**
	 * 把以1_2_3|2_3_4类似格式的字符串分解成HashMap<K,List<V>>
	 * 
	 * @param str
	 * @param itemsRegex
	 *            项与项之间的分割符,例如上面的|
	 * @param valueRegex
	 *            项值之间的分割符,例如上面的_
	 * 
	 * @param keyClz
	 *            key类型
	 * @param valueClz
	 *            value类型
	 * @return 没有数据返回空元素的集合
	 */
	public static <K, V> Map<K, List<V>> stringToMapList(String str,
			String itemsRegex, String valueRegex, Class<K> keyClz,
			Class<V> valueClz) {
		if (CommonUtil.isNull(str)) {
			return new HashMap<K, List<V>>();
		}
		String[] arr = split(str, itemsRegex);
		Map<K, List<V>> map = new HashMap<K, List<V>>(arr.length);
		for (String s : arr) {
			String[] subArr = split(s, valueRegex);
			List<V> list = new ArrayList<V>(subArr.length - 1);
			for (int i = 1; i < subArr.length; i++) {
				list.add(getValueByStr(subArr[i], valueClz));
			}
			map.put(getValueByStr(subArr[0], keyClz), list);
		}
		return map;
	}

	/**
	 * 把以1_2_3|2_3_4类似格式的字符串分解成HashMap<K,List<V>>
	 * 
	 * @param str
	 * @param itemsRegex
	 *            项与项之间的分割符,例如上面的|
	 * @param valueRegex
	 *            项值之间的分割符,例如上面的_
	 * 
	 * @param keyClz
	 *            key类型
	 * @param valueClz
	 *            value类型
	 * @return 没有数据返回空元素的集合
	 */
	public static <K, V> Map<K, V[]> stringToMapArray(String str,
			String itemsRegex, String valueRegex, Class<K> keyClz,
			Class<V> valueClz) {
		if (CommonUtil.isNull(str)) {
			return new HashMap<K, V[]>();
		}
		String[] arr = split(str, itemsRegex);
		Map<K, V[]> map = new HashMap<K, V[]>(arr.length);
		for (String s : arr) {
			String[] subArr = split(s, valueRegex);
			map.put(getValueByStr(subArr[0], keyClz),
					stringToArray(subArr, valueClz, 1));
		}
		return map;
	}

	/**
	 * 把HashMap分解成以1_a|1_b格式的字符串
	 * 
	 * @param map
	 * @return
	 */
	public static <K, V> String mapArrayToString(Map<K, V[]> map,
			String itemsRegex, String valueRegex) {
		StringBuilder bf = null;
		if (map != null && map.size() > 0) {
            for (Map.Entry<K, V[]> entry : map.entrySet()) {
                V[] array = entry.getValue();
				if (array == null || array.length == 0) {
					continue;
				}
				if (bf == null) {
					bf = new StringBuilder();
				} else {
					bf.append(itemsRegex);
				}
                bf.append(entry.getKey());
				for (V obj : array) {
					bf.append(valueRegex).append(obj);
				}
			}
		}
		return bf == null ? null : bf.toString();
	}

	/**
	 * 把HashMap分解成以1_a|1_b格式的字符串
	 * 
	 * @param map
	 * @return
	 */
	public static <K, V> String mapListToString(Map<K, List<V>> map,
			String itemsRegex, String valueRegex) {
		StringBuilder bf = null;
		if (map != null && map.size() > 0) {
            for (Map.Entry<K, List<V>> entry : map.entrySet()) {
                List<V> list = entry.getValue();
				if (CommonUtil.isCollectionEmpty(list)) {
					continue;
				}
				if (bf == null) {
					bf = new StringBuilder();
				} else {
					bf.append(itemsRegex);
				}
                bf.append(entry.getKey());
				for (V obj : list) {
					bf.append(valueRegex).append(obj);
				}
			}
		}
		return bf == null ? null : bf.toString();
	}

	/**
	 * 分割字符串
	 * 
	 * @param str
	 * @param regex
	 * @return
	 */
	public static String[] split(String str, String regex) {
		if (regex.equals("|")) {
			regex = "\\|";
		} else if (regex.equals(",")) {
			regex = REGEX_DOU_HAO;
		} else if (regex.equals("，")) {
			regex = REGEX_DOU_HAO;
		} else if (regex.equals("^")) {
			regex = "\\^";
		}
		return str.split(regex);
	}

	@SuppressWarnings("unchecked")
	private static <T> T getValueByStr(String str, Class<T> clz) {
		if (clz == Integer.class) {
			return (T) Integer.valueOf(str);
		} else if (clz == Float.class) {
			return (T) Float.valueOf(str);
		} else if (clz == Long.class) {
			return (T) Long.valueOf(str);
		} else if (clz == String.class) {
			return (T) str;
		}
		return null;
	}

	/**
	 * 把以1_2,1_3类似格式的字符串分解成HashMap<K,V> V为Long、Integer、String时使用
	 * 
	 * @param str
	 * @param keyClz
	 *            key类型
	 * @param valueClz
	 *            value类型
	 * @return
	 */
	public static <K, V> Map<K, V> stringToMap(String str, Class<K> keyClz,
			Class<V> valueClz) {
		return stringToMap(str, REGEX_DOU_HAO, DELIMITER_INNER_ITEM, keyClz,
				valueClz);
	}

	/**
	 * 把HashMap分解成以1_a,1_b格式的字符串 V为Long、Integer、String时使用
	 * 
	 * @param map
	 * @return
	 */
	public static <K, V> String mapToString(Map<K, V> map) {
		return mapToString(map, DELIMITER_BETWEEN_ITEMS, DELIMITER_INNER_ITEM);
	}

	/**
	 * 把HashMap分解成以1_a|1_b格式的字符串 V为Long、Integer、String时使用
	 * 
	 * @param map
	 * @return
	 */
	public static <K, V> String mapToString(Map<K, V> map, String itemsRegex,
			String valueRegex) {
		StringBuilder bf = null;
		if (map != null && map.size() > 0) {
            for (Map.Entry<K, V> entry : map.entrySet()) {
                V obj = entry.getValue();
				if (obj != null) {
					if (bf == null) {
						bf = new StringBuilder();
					} else {
						bf.append(itemsRegex);
					}
                    bf.append(entry.getKey()).append(valueRegex).append(obj);
				}
			}
		}
		return bf == null ? null : bf.toString();
	}

	/**
	 * 替换字符串变量
	 * 
	 * @param src
	 *            源字符串
	 * @param param
	 *            变量
	 * @param paramValue
	 *            变量值数值
	 * @return
	 */
	public static String replaceString(String src, String param,
			Object... paramValue) {
		if (paramValue == null || paramValue.length == 0) {
			return src;
		}
		StringBuilder sb = new StringBuilder(src);
		// 变量参数
		int paramLength = param.length();
		int index = 0;
		for (Object value : paramValue) {
			index = sb.indexOf(param);
			if (index < 0) {
				break;
			}
			sb.replace(index, index + paramLength, value.toString());
		}
		return sb.toString();
	}

	/**
	 * 替换字符串变量
	 * 
	 * @param src
	 *            源字符串
	 * @param param
	 *            变量
     * @param params
	 *            变量值数值
	 * @return
	 */
	public static String replaceString(String src, Map<String, Object> params) {
		StringBuffer sb = new StringBuffer(src);
        for (Map.Entry<String, Object> entry : params.entrySet()) {
            int index = sb.indexOf(entry.getKey());
			while (index > 0) {
                sb.replace(index, index + entry.getKey().length(), entry.getValue()
						.toString());
                index = sb.indexOf(entry.getKey());
			}
		}
		return sb.toString();
	}

	/**
	 * 把类似字符串a|b|c分割成Set<T>
	 * 
	 * @param <T>
	 * @param str
	 * @param itemsRegex
	 * @param clz
	 * @return
	 */
	public static <T> Set<T> stringToSet(String str, String itemsRegex,
			Class<T> clz) {
		if (CommonUtil.isNull(str)) {
			return new HashSet<T>();
		}
		String[] arr = split(str, itemsRegex);
		Set<T> result = new HashSet<T>(arr.length);
		for (String value : arr) {
			result.add(getValueByStr(value, clz));
		}
		return result;
	}

	/**
	 * 把Set<T>组装成以指定分割的字符串 T为Long、Integer、String时使用
	 * 
	 * @param <T>
	 * @param set
	 * @param regex
	 * @return
	 */
	public static <T> String setToString(Set<T> set, String regex) {
		if (CommonUtil.isCollectionEmpty(set)) {
			return null;
		}
		StringBuilder bf = null;
		for (T value : set) {
			if (bf == null) {
				bf = new StringBuilder();
			} else {
				bf.append(regex);
			}
			bf.append(value);
		}
		return bf == null ? null : bf.toString();
	}

	/**
	 * 连接数组
	 * 
	 * @param s
	 *            分隔符
	 * @param objects
	 */
	public static String join(String s, Object... objects) {
		if (objects.length == 0) {
			return "";
		}
		StringBuilder sb = new StringBuilder(objects[0].toString());
		for (int i = 1; i < objects.length; i++) {
			sb.append(s).append(objects[i]);
		}
		return sb.toString();
	}

	/**
	 * 连接数组
	 * 
	 * @param s
	 *            分隔符
	 * @param ls
	 */
	public static String join(String s, List<?> ls) {
		if (ls.size() == 0) {
			return "";
		}
		StringBuilder sb = new StringBuilder(ls.get(0).toString());
		for (int i = 1; i < ls.size(); i++) {
			sb.append(s).append(ls.get(i));
		}
		return sb.toString();
	}

	/**
	 * 大写首字母
	 */
	public static String upFirst(String str) {
		return str.substring(0, 1).toUpperCase().concat(str.substring(1));
	}

	/**
	 * 首字母大写
	 * 
	 * @author Craig
	 * @param str
	 */
	public static String upFirst1(String str) {
		char[] strs = str.toCharArray();
		if ((strs[0] >= 'a' && strs[0] <= 'z')) {
			strs[0] -= 32;
			return String.valueOf(strs);
		} else {
			return upFirst(str);
		}
	}

	/**
	 * 下划线风格转小写驼峰
	 */
	public static String underlineToLowerCamal(String s) {
		Object[] ss = s.split("_");
		for (int i = 1; i < ss.length; i++) {
			ss[i] = upFirst1(ss[i].toString());
		}
		return join("", ss);
	}

	/**
	 * 下划线风格转大写驼峰
	 */
	public static String underlineToUpperCamal(String s) {
		Object[] ss = s.split("_");
		for (int i = 0; i < ss.length; i++) {
			ss[i] = upFirst1(ss[i].toString());
		}
		return join("", ss);
	}

	/**
	 * 驼峰转下划线,未处理大小写
	 */
	public static String camalToUnderline(String s) {
		StringBuilder sb = new StringBuilder();
		if (s.length() > 0) {
			sb.append(s.charAt(0));
		}
		for (int i = 1; i < s.length(); i++) {
			char c = s.charAt(i);
			if (Character.isUpperCase(c)) {
				sb.append("_");
			}
			sb.append(c);
		}
		return sb.toString();
	}

	/**
	 * 判断字符串为空（null或者""）
	 * 
	 * <pre>
	 * StringUtils.isEmpty(null) = true
	 * StringUtils.isEmpty("") = true
	 * StringUtils.isEmpty(" ") = false
	 * StringUtils.isEmpty("bob") = false
	 * StringUtils.isEmpty("  bob  ") = false
	 * </pre>
	 * 
	 * @param s
	 * @return
	 */
	public static boolean isEmpty(String s) {
		return s == null || s.length() == 0;
	}

	/**
	 * 判断字符串不为空（null或者""）
	 * 
	 * <pre>
	 * StringUtils.isNotEmpty(null) = false
	 * StringUtils.isNotEmpty("") = false
	 * StringUtils.isNotEmpty(" ") = true
	 * StringUtils.isNotEmpty("bob") = true
	 * StringUtils.isNotEmpty("  bob  ") = true
	 * </pre>
	 * 
	 * @param s
	 * @return
	 */
	public static boolean isNotEmpty(String s) {
		return !StringUtil.isEmpty(s);
	}

	/**
	 * 判断字符串为空白字符串(null或者""或者" ")
	 * 
	 * <pre>
	 * StringUtils.isBlank(null) = true
	 * StringUtils.isBlank("") = true
	 * StringUtils.isBlank(" ") = true
	 * StringUtils.isBlank("bob") = false
	 * StringUtils.isBlank(" bob ") = false
	 * </pre>
	 * 
	 * @param s
	 * @return
	 */
	public static boolean isBlank(String s) {
		int strLen;
		if (s == null || (strLen = s.length()) == 0) {
			return true;
		}

		for (int i = 0; i < strLen; i++) {
			if (Character.isWhitespace(s.charAt(i)) == false) {
				return false;
			}
		}
		return true;
	}

	/**
	 * 判断字符串不为空白字符串(null或者""或者" ")
	 * 
	 * <pre>
	 * StringUtils.isNotBlank(null) = false
	 * StringUtils.isNotBlank("") = false
	 * StringUtils.isNotBlank(" ") = false
	 * StringUtils.isNotBlank("bob") = true
	 * StringUtils.isNotBlank(" bob ") = true
	 * </pre>
	 * 
	 * @param s
	 * @return
	 */
	public static boolean isNotBlank(String s) {
		return !StringUtil.isBlank(s);
	}

	/**
	 * 截取字符串
	 * 
	 * <pre>
	 * StringUtils.substringBefore("ajp_djp_gjp_j", "")  = ""
	 * StringUtils.substringBefore("ajp_djp_gjp_j", null)  = ""
	 * StringUtils.substringBefore("ajp_djp_gjp_j", "jp_")  = "a"
	 * StringUtils.substringBefore("ajp_djp_gjp_j", "jk_")  = "ajp_djp_gjp_j"
	 * </pre>
	 * 
	 * @param str
	 *            被截取的字符串
	 * @param separator
	 *            截取分隔符
	 * @return
	 */
	public static String substringBefore(String str, String separator) {
		if ((isEmpty(str)) || (separator == null)) {
			return str;
		}
		if (separator.isEmpty()) {
			return "";
		}
		int pos = str.indexOf(separator);
		if (pos == -1) {
			return str;
		}
		return str.substring(0, pos);
	}

	/**
	 * 截取字符串
	 * 
	 * <pre>
	 * StringUtils.substringAfter("ajp_djp_gjp_j", "jp_")  = "defjp_ghi"
	 * StringUtils.substringAfter("ajp_djp_gjp_j", "")  = "ajp_djp_gjp_j"
	 * StringUtils.substringAfter("ajp_djp_gjp_j", null)  = "ajp_djp_gjp_j"
	 * StringUtils.substringAfter("ajp_djp_gjp_j", "jk_")  = ""
	 * </pre>
	 * 
	 * @param str
	 *            被截取的字符串
	 * @param separator
	 *            截取分隔符
	 * @return
	 */
	public static String substringAfter(String str, String separator) {
		if (isEmpty(str)) {
			return str;
		}
		if (separator == null) {
			return "";
		}
		int pos = str.indexOf(separator);
		if (pos == -1) {
			return "";
		}
		return str.substring(pos + separator.length());
	}

	/**
	 * 截取字符串
	 * 
	 * <pre>
	 * StringUtils.substringBeforeLast("ajp_djp_gjp_j", "")  = "ajp_djp_gjp_j"
	 * StringUtils.substringBeforeLast("ajp_djp_gjp_j", null)  = "ajp_djp_gjp_j"
	 * StringUtils.substringBeforeLast("ajp_djp_gjp_j", "jk_")  = "ajp_djp_g"
	 * StringUtils.substringBeforeLast("ajp_djp_gjp_j", "jp_")  = "ajp_djp_g"
	 * </pre>
	 * 
	 * @param str
	 *            被截取的字符串
	 * @param separator
	 *            截取分隔符
	 * @return
	 */
	public static String substringBeforeLast(String str, String separator) {
		if ((isEmpty(str)) || (isEmpty(separator))) {
			return str;
		}
		int pos = str.lastIndexOf(separator);
		if (pos == -1) {
			return str;
		}
		return str.substring(0, pos);
	}

	/**
	 * 截取字符串
	 * 
	 * <pre>
	 * StringUtils.substringAfterLast("ajp_djp_gjp_j", "")  = ""
	 * StringUtils.substringAfterLast("ajp_djp_gjp_j", null)  = ""
	 * StringUtils.substringAfterLast("ajp_djp_gjp_j", "jk_")  = ""
	 * StringUtils.substringAfterLast("ajp_djp_gjp_j", "jp_")  = "j"
	 * </pre>
	 * 
	 * @param str
	 *            被截取的字符串
	 * @param separator
	 *            截取分隔符
	 * @return
	 */
	public static String substringAfterLast(String str, String separator) {
		if (isEmpty(str)) {
			return str;
		}
		if (isEmpty(separator)) {
			return "";
		}
		int pos = str.lastIndexOf(separator);
		if ((pos == -1) || (pos == str.length() - separator.length())) {
			return "";
		}
		return str.substring(pos + separator.length());
	}

	/**
	 * 返回字符串长度
	 * 
	 * @param value
	 * @return
	 */
	public static int stringLength(String value) {
		int valueLength = 0;
		String chinese = "[\u0391-\uFFE5]";
		/* 获取字段值的长度，如果含中文字符，则每个中文字符长度为2，否则为1 */
		for (int i = 0; i < value.length(); i++) {
			/* 获取一个字符 */
			String temp = value.substring(i, i + 1);
			/* 判断是否为中文字符 */
			if (temp.matches(chinese)) {
				/* 中文字符长度为2 */
				valueLength += 2;
			} else {
				/* 其他字符长度为1 */
				valueLength += 1;
			}
		}
		return valueLength;
	}

	private static Pattern namePattern = Pattern
			.compile("[\u4e00-\u9fa50-9a-zA-Z]+");

	/**
	 * 
	 * @param name
	 * @return
	 */
	public static boolean isNameIll(String name) {
		Matcher matcher = namePattern.matcher(name);
		StringBuilder sb = new StringBuilder();
		while (matcher.find()) {
			sb.append(matcher.group());
		}
		String ill = sb.toString();
		if (!ill.equals(name))
			return false; // 有特殊字符
		return true;
	}

	/**
	 * 字符串转浮点数组，主要是为了不使用包装类
	 * 
	 * @param str
	 * @param regex
	 * @return
	 */
	public static float[] stringToFloatArray(String str, String regex) {
		if (str == null || str.length() == 0) {
			return null;
		}
		String[] arr = split(str, regex);

		float[] result = new float[arr.length];
		for (int i = 0; i < arr.length; i++) {
			result[i] = Float.parseFloat(arr[i]);
		}
		return result;
	}

	/**
	 * 字符串转整形数组，主要是为了不使用包装类
	 * 
	 * @param str
	 * @param regex
	 * @return
	 */
	public static int[] stringToIntArray(String str, String regex) {
		if (str == null || str.length() == 0) {
			return null;
		}
		String[] arr = split(str, regex);

		int[] result = new int[arr.length];
		for (int i = 0; i < arr.length; i++) {
			result[i] = Integer.parseInt(arr[i]);;
		}
		return result;
	}
	
	/**
	 * 是否有SQL注入字符
	 * @param strInput
	 * @return
	 */
	public static boolean containsSqlInjectIllegalCh(String strInput) {
        //"[`~!@#$%^&*()+=|{}':;',\\[\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]"
        String regEx = "['=_<>;\"]";
        Pattern p = Pattern.compile(regEx);
        Matcher m = p.matcher(strInput);
        if (m.find()) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * 获取字符串显示的长度(单字节一个长度，双字节的两个长度)
     *
     * @param str
     * @return
     */
    public static int getShowLength(String str) {
        if (StringUtils.isEmpty(str)) {
            return 0;
        }
        int length = str.length();
        // 双字节个数
        int doubleByteLength = getDoubleByteNum(str);

        return doubleByteLength + length;
    }

    /**
     * 获取双字节字符个数
     *
     * @param str
     * @return
     */
    public static int getDoubleByteNum(String str) {
        if (StringUtils.isBlank(str)) {
            return 0;
        }
        Pattern p = Pattern.compile("[^\\x00-\\xff]");
        Matcher m = p.matcher(str);
        int i = 0;
        while (m.find()) {
            i++;
        }
        return i;
    }
}
