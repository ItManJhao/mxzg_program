/**
 * 
 */
package com.ayjs.mxzg.common.handler;

/**
 * @author YY
 *
 */
public abstract class ProtocolHandler {
	
	public ProtocolHandler() {
		ProtocolDispatcher.register(this);
	}
}
