/**
 * 
 */
package com.ayjs.mxzg.common.service;

/**
 * @author YY
 *
 */
public abstract class BaseService {
	
	
	public BaseService() {
		
	}
	
	public abstract void handleOnServerStarting();
	
	public abstract void handleOnServerReady();
}
