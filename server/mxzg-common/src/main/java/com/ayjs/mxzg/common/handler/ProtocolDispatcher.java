/**
 * 
 */
package com.ayjs.mxzg.common.handler;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author YY
 *
 */
public class ProtocolDispatcher {

	private static Map<Integer, HandlerExecutor> executors = new HashMap<>();
	
	public static void register(ProtocolHandler controller) {
		Method[] methods = controller.getClass().getDeclaredMethods();
		for(Method method : methods) {
			CMD cmd = method.getAnnotation(CMD.class);
			if(cmd == null) {
				continue;
			}
			//防止重复的协议号被注册
			if(executors.containsKey(cmd.id())) {
				throw new RuntimeException("重复的协议号定义" + controller.getClass().getSimpleName() + "." + method.getName()
						+ "[" + cmd.id() + "]");
			}
			try {
				executors.put(cmd.id(), new HandlerExecutor(cmd, controller, method));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	public static HandlerExecutor getExecutor(int cmd) {
		return executors.get(cmd);
	}
	
	public static void printAllExecutor() {
		List<Integer> sortList = new ArrayList<>(executors.keySet());
		Collections.sort(sortList);
		
		for(Integer cmdId : sortList) {
			HandlerExecutor executor = executors.get(cmdId);
			String msgClassName = executor.getMessage().getClass().getSimpleName();
			System.out.println(cmdId + "," + msgClassName);
		}
	}
}
