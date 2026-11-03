/**
 * 
 */
package com.ayjs.mxzg.message.module.error;

import com.ayjs.mxzg.message.cross.RemoteServerMessage;

import lombok.Getter;
import lombok.Setter;

/**
 * @author YY
 *
 */
@Getter
@Setter
public class ErrorMessage implements RemoteServerMessage {
	private long rid;
	private int serverId;
	private int errorCode;
	
	@Override
	public int serverId() {
		return serverId;
	}
}
