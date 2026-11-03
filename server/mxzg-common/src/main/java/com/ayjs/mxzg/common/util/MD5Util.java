package com.ayjs.mxzg.common.util;

import java.io.UnsupportedEncodingException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



public class MD5Util {

	private static Logger logger = LoggerFactory.getLogger(MD5Util.class);

	private static String getMD5(byte[] source) {
		String s = null;
		char hexDigits[] = { // 用来将字节转换成 16 进制表示的字符
		'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd',
				'e', 'f' };
		try {
			java.security.MessageDigest md = java.security.MessageDigest
					.getInstance("MD5");
			md.update(source);
			byte tmp[] = md.digest(); // MD5 的计算结果是一个 128 位的长整数，用字节表示就是 16 个字节
			char str[] = new char[16 * 2]; // 每个字节用 16 进制表示的话，使用两个字符，所以表示成 16
			// 进制需要 32 个字符
			int k = 0; // 表示转换结果中对应的字符位置
			for (int i = 0; i < 16; i++) { // 从第一个字节开始，对 MD5 的每一个字节转换成 16
				// 进制字符的转换
				byte byte0 = tmp[i]; // 取第 i 个字节
				str[k++] = hexDigits[byte0 >>> 4 & 0xf];
				str[k++] = hexDigits[byte0 & 0xf]; // 取字节中低 4 位的数字转换
			}
			s = new String(str); // 换后的结果转换为字符串

		} catch (Exception e) {
			logger.error("", e);
		}
		return s;
	}

	/**
	 * @param source
	 * @return
	 */
	public static String getMD5(String source) {
		try {
			byte[] b = source.getBytes("UTF-8");
			return getMD5(b);
		} catch (UnsupportedEncodingException e) {
			logger.error("StringUtils.getMD5(String source)", e);
			return "";
		}
	}
	
	public static void main(String[] args) {
		System.out.println(getMD5("Recharge.chargeCallback06480011111111165925468561^-^ayjsgame!@#api&201912"));
	}

	/**
	 * 根据列表数据生成md5
	 * @param data
	 * @return
	 */
	public static String getMD5(List<Object> data) {
		StringBuilder builder = new StringBuilder(60);
		for (Object str : data) {
			builder.append(str);
		}
		return MD5Util.getMD5(builder.toString());
	}
}
