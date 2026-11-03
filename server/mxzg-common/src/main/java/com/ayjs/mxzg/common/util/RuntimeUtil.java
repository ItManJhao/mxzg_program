/**
 * 
 */
package com.ayjs.mxzg.common.util;

import java.text.DecimalFormat;

/**
 * @author YY
 *
 */
public class RuntimeUtil {

	public static class RuntimeJVM {
		private String free;
		private String max;
		private String total;
		private String left;
		private String used;
		public String getFree() {
			return free;
		}
		public void setFree(String free) {
			this.free = free;
		}
		public String getMax() {
			return max;
		}
		public void setMax(String max) {
			this.max = max;
		}
		public String getTotal() {
			return total;
		}
		public void setTotal(String total) {
			this.total = total;
		}
		public String getLeft() {
			return left;
		}
		public void setLeft(String left) {
			this.left = left;
		}
		public String getUsed() {
			return used;
		}
		public void setUsed(String used) {
			this.used = used;
		}
	}
	
	public static RuntimeJVM jvmStatus() {
		RuntimeJVM runtime = new RuntimeJVM();
		
		//当前JVM空闲内存
		long free = Runtime.getRuntime().freeMemory();
		//最大可用内存，对应-Xmx参数
		long max = Runtime.getRuntime().maxMemory();
		//当前JVM占用的内存总数，已申请的内存量，其值相当于当前JVM已使用的内存及freeMemory()的总和
		long total = Runtime.getRuntime().totalMemory();
		//剩余可用的内存量
		long left = max - total + free;
		//已使用的内存量
		long used = total - free;
		
		runtime.setFree(formatByteSize(free));
		runtime.setMax(formatByteSize(max));
		runtime.setTotal(formatByteSize(total));
		runtime.setLeft(formatByteSize(left));
		runtime.setUsed(formatByteSize(used));
		
		return runtime;
	}
	
	public static String formatByteSize(long size) {
		DecimalFormat df = new DecimalFormat("#.00");
		String value = "";
		if (size < 1024) {
			value = df.format((double) size) + "B";
		} else if (size < 1048576) {
			value = df.format((double) size / 1024) + "K";
		} else if (size < 1073741824) {
			value = df.format((double) size / 1048576) + "M";
		} else {
			value = df.format((double) size / 1073741824) + "G";
		}
		return value;
	}
	
}
