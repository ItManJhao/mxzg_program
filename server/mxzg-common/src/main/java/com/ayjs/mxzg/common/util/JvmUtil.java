/**
 * 
 */
package com.ayjs.mxzg.common.util;

import java.text.DecimalFormat;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
public class JvmUtil {
	
	public static void scanJvm() {
		long freeMemory = Runtime.getRuntime().freeMemory();// 当前JVM空闲内存
		long maxJVM = Runtime.getRuntime().maxMemory();// 最大可用内存，对应-Xmx
		long totalJVM = Runtime.getRuntime().totalMemory();// 当前JVM占用的内存总数，其值相当于当前JVM已使用的内存及freeMemory()的总和
		long leftVM = maxJVM - totalJVM + freeMemory;
		long usedJVM = totalJVM - freeMemory;
		log.info("maxJVM:" + formetSize(maxJVM) + ",totalJVM:" + formetSize(totalJVM) + ",leftVM:" + formetSize(leftVM)
				+ ",usedJVM:" + formetSize(usedJVM));
	}
	
	private static String formetSize(long size) {
		DecimalFormat df = new DecimalFormat("#.00");
		String sizeString = "";
		if (size < 1024) {
			sizeString = df.format((double) size) + "B";
		} else if (size < 1048576) {
			sizeString = df.format((double) size / 1024) + "K";
		} else if (size < 1073741824) {
			sizeString = df.format((double) size / 1048576) + "M";
		} else {
			sizeString = df.format((double) size / 1073741824) + "G";
		}
		return sizeString;
	}
	
}
