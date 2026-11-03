/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.role.event;

import com.ayjs.mxzg.config.struct.GameEvent;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class RoleExpAddEvent {
	private long rid;
	private long addCount;
	private long curr;
	private int oldLv;
	private int currLv;
	private GameEvent gameEvent;
}
