package com.ayjs.mxzg.common.util;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class ShareCodeUtil {
	/** 自定义进制（选择你想要的进制数，不能重复且最好不要0、1这些容易混淆的字符） */
	private static final char[] r = new char[] { '9', 'C', 'V', 'M', '6', 'X', 'D', '8', 'U', '5', 'N', 'B', 'E', '3',
			'Q', 'K', 'R', 'P', 'G', '2', 'A', '7', 'W', 'J', 'H', 'Z', 'S', 'Y', 'T', '4' };

	/**
	 * 断位字符，定义一个字符用来补全邀请码长度（该字符前面是计算出来的邀请码，后面是用来补全用的）
	 */
	private static final char b = 'F';

	/** 进制长度 */
	private static final int binLen = r.length;

	/** 邀请码长度 */
	private static final int s = 7;

	/**
	 * 根据ID生成固定长度的邀请码，7位
	 * @param id
	 * @return 随机码
	 */
	public static String toRegularCode(long id) {
		char[] buf = new char[s];
		int charPos = s;

		while ((id / binLen) > 0) {
			int ind = (int) (id % binLen);
			buf[--charPos] = r[ind];
			id /= binLen;
		}
		buf[--charPos] = r[(int) (id % binLen)];
		String str = new String(buf, charPos, (s - charPos));
		// 不够长度的自动补全
		if (str.length() < s) {
			StringBuilder sb = new StringBuilder();
			sb.append(b);

			Random rnd = new Random();
			for (int i = 1; i < s - str.length(); i++) {
				sb.append(r[rnd.nextInt(binLen)]);
			}
			// sb.append(e.subSequence(0, s - str.length()));
			str += sb.toString();
		}
		return str;
	}
	
	/**
	 * 根据ID生成不固定长度的邀请码
	 * @param id
	 * @return
	 */
	public static String toDynamicsCode(long id) {
		List<Character> buf = new ArrayList<>();
		while ((id / binLen) > 0) {
			int ind = (int) (id % binLen);
			buf.add(r[ind]);
			id /= binLen;
		}
		buf.add(r[(int) (id % binLen)]);
		Collections.reverse(buf);
		
		StringBuilder builder = new StringBuilder();
		for(Character c : buf) {
			builder.append(c);
		}
		return builder.toString();
	}
	
	

	/**
	 * 根据邀请码转换回ID
	 * @param 邀请码
	 * @return ID
	 */
	public static long codeToId(String code) {
		char chs[] = code.toCharArray();
		long res = 0L;
		for (int i = 0; i < chs.length; i++) {
			int ind = 0;
			for (int j = 0; j < binLen; j++) {
				if (chs[i] == r[j]) {
					ind = j;
					break;
				}
			}
			if (chs[i] == b) {
				break;
			}
			if (i > 0) {
				res = res * binLen + ind;
			} else {
				res = ind;
			}
		}
		return res;
	}

	public static void printAnotherSequence() {
		char[] chars = new char[] {'2','3','4','5','6','7','8','9','A','B','C','D','E','G','H','J','K','M','N','P','Q','R','S','T','U','V','W','X','Y','Z'};
		List<String> list = new ArrayList<>();
		for(char ch : chars) {
			list.add(Character.toString(ch));
		}
		Collections.shuffle(list);
		
		StringBuilder builder = new StringBuilder();
		for(String s : list) {
			builder.append("'").append(s).append("',");
		}
		System.out.println(builder.toString());
	}
	
	// 测试代码
	public static void main(String[] args) {
		
		
		System.out.println(toDynamicsCode(100000011000723l));
		System.out.println(toRegularCode(1000723l));
		
		System.out.println(codeToId("XVEQDJ766M"));
		System.out.println(codeToId("C8CY3FX"));
		
		Map<String, Long> map = new HashMap<>();
		Map<Long, String> map2 = new HashMap<>();

		long maxId = 0;

//		for (long i = 0; i <= 1000000; i++) {
//			for (int j = 0; j < 2; j++) {
//				String s = ShareCodeUtil.toSerialCode(i * 10 + j + 1);
//				long l = ShareCodeUtil.codeToId(s);
//				map.put(s, l);
//				map2.put(l, s);
//				if (l > maxId) {
//					maxId = l;
//				}
//			}
//		}

		// for (Map.Entry<String, Long> entry : map.entrySet()) {
		// System.out.println(entry.getKey() + " : " + entry.getValue());
		// }
		System.out.println(map.size());
		System.out.println(map2.size());
		System.out.println(maxId);
	}
}
