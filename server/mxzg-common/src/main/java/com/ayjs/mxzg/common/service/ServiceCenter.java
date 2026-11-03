/**
 * 
 */
package com.ayjs.mxzg.common.service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author YY
 *
 */
public class ServiceCenter {

	private static Map<Class<?>, BaseService> serviceMap = new ConcurrentHashMap<>();

	public static void registerService(BaseService service) {
		if(serviceMap.containsKey(service.getClass())) {
			throw new RuntimeException("重复的Service[" + service.getClass() + "]被注册");
		}
		serviceMap.put(service.getClass(), service);
	}

	public static Map<Class<?>, BaseService> getServiceMap() {
		return serviceMap;
	}
	
	public static void handleOnServerStart() {
		for(BaseService service : serviceMap.values()) {
			service.handleOnServerStarting();
		}
		for(BaseService service : serviceMap.values()) {
			service.handleOnServerReady();
		}
	}
	
	
}
