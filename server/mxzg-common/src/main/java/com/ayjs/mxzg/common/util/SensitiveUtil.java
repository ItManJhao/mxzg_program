/**
 * 
 */
package com.ayjs.mxzg.common.util;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author YY
 *
 */
public class SensitiveUtil {

	private static Logger logger = LoggerFactory.getLogger(SensitiveUtil.class);

	/**
	 * 敏感词缓存Map(第一个字符，其余字符的List)
	 */
	private static Map<String, List<String>> SensitiveMap;
	/**
	 * 过滤字符缓存
	 */
	private static Map<Integer, String> FilterMap;
	/**
	 * 替换的字符
	 */
	private static final String FilterChar = "*";
	/**
	 * 敏感字最长长度
	 */
	private static int WORD_MAX_LENGTH = 0;

	private static String sensitiveTxtFile = "";
	
	/**
	 * 敏感字过滤
	 * 
	 * @param str
	 * @return
	 */
	public static String sensitiveFilter(String str) {
		str = str.trim();
		String[] strs = str.split("");
		int index = 0;
		for (int i = 0; i < strs.length; i++) {
			String temp = strs[i];
			if (index == 0 && CommonUtil.isNull(temp)) {
				continue;
			}
			List<String> map = SensitiveMap.get(temp);
			if (map == null) {
				index++;
				continue;
			} else {
				int j = index + 1;
				for (String key : map) {
					if (j + key.length() > strs.length) {
						continue;
					}
					if (j + key.length() > str.length()) {
						continue;
					}
					if (key.equals(str.substring(j, j + key.length()))) {
						str = str.replaceAll(temp + key, getFilter(temp + key));
						j += key.length();
						break;
					}
				}
				index++;
			}
		}
		return str;
	}

	private final Pattern p = Pattern
			.compile("[+=＋＝]|([１２３４５６７８９０㈠㈡㈢㈣㈤㈥㈦㈧㈨⑴⑵⑶⑷⑸⑹⑺⑻⑼⒈⒉⒊⒋⒌⒍⒎⒏⒐①②④⑤⑥⑦⑧⑨〇一二三四五六七八九百佰千仟万亿壹貳叁肆陸柒捌汣].*){3,}|([0-9].*){6,}");

	/**
	 * 是否有敏感字符
	 */
	public boolean hasForbidStr(String str) {
		if (str == null) {
			return false;
		}
		str = str.replaceAll("\\\\[0-9][0-9]", "");
		Matcher m = p.matcher(str);
		return m.find();
	}

	/**
	 * 是否有敏感字
	 * 
	 * @param str
	 * @return
	 */
	public static String hasSensitive(String str) {
		str = str.trim();
		String[] strs = str.split("");
		int index = 0;
		for (int i = 0; i < strs.length; i++) {
			String temp = strs[i];
			if (index == 0 && CommonUtil.isNull(temp)) {
				continue;
			}
			List<String> map = SensitiveMap.get(temp);
			if (map == null || map.isEmpty()) {
				index++;
				continue;
			} else {
				int j = index + 1;
				for (String key : map) {
					if (j + key.length() > strs.length) {
						continue;
					}
					if (j + key.length() > str.length()) {
						continue;
					}
					if (key.equals(str.substring(j, j + key.length()))) {
						return temp + key;
					}
				}
				index++;
			}
		}
		return null;
	}

	/**
	 * 组装屏蔽字符
	 * 
	 * @param word
	 * @return
	 */
	private static String getFilter(String word) {
		String filter = FilterMap.get(word.length());
		if (filter != null) {
			return filter;
		}
		return "**";
	}

	/**
	 * 敏感字加载
	 */
	public static void init(String sensitiveTxtFile) {
		if(sensitiveTxtFile == null || "".equals(sensitiveTxtFile)) {
			return;
		}
		SensitiveUtil.sensitiveTxtFile = sensitiveTxtFile;
		loadSensitiveWord();
		loadFilterMap();
	}

	private static void loadSensitiveWord() {
		try {
			BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(
					sensitiveTxtFile), "UTF-8"));
			
			StringBuilder sb = new StringBuilder(20000);
			while (reader.ready()) {
				sb.append(reader.readLine());
			}
			reader.close();
			if (sb.length() == 0) {
				return;
			}
			String[] dirtyWordArr = sb.toString().trim().split("、");
			logger.info("加载屏蔽字地址：" + sensitiveTxtFile + " 屏蔽字数量:" + dirtyWordArr.length);
			fillSensitiveMap(dirtyWordArr);
		} catch (IOException e) {
			logger.error("加载屏蔽字库出错", e);
		}
	}
	
	public static void loadSensitiveWord(String[] words) {
		fillSensitiveMap(words);
	}
	

	private static void loadFilterMap() {
		Map<Integer, String> tempMap = new HashMap<>(WORD_MAX_LENGTH);
		String filter = "";
		for (int i = 1; i <= WORD_MAX_LENGTH; i++) {
			filter += FilterChar;
			tempMap.put(i, filter);
		}
		FilterMap = tempMap;
	}

	/**
	 * 添加敏感词
	 * 
	 * @param word
	 */
	private static void fillSensitiveMap(String[] words) {
		Map<String, List<String>> tempMap = new HashMap<>();
		for (int i = 0; i < words.length; i++) {
			String word = words[i].trim();
			if (word == null || "".equals(word)) {
				continue;
			}
			if (word.length() > WORD_MAX_LENGTH) {
				WORD_MAX_LENGTH = word.length();
			}
			String firstChar = word.substring(0, 1);
			List<String> wordList = tempMap.get(firstChar);
			if (wordList == null) {
				wordList = new ArrayList<>();
				tempMap.put(firstChar, wordList);
			}
			if (!wordList.contains(word.substring(1))) {
				wordList.add(word.substring(1));
			}
		}
		SensitiveMap = tempMap;
	}
}
