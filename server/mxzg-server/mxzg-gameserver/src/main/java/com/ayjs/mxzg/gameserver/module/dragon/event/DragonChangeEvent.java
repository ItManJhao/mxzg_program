/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.dragon.event;

import com.ayjs.mxzg.config.struct.GameEvent;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class DragonChangeEvent {
	private long rid;
	private GameEvent gameEvent;
}
