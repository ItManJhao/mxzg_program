/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.backpack.event;

import com.ayjs.mxzg.config.struct.GameEvent;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class GoldAddEvent {
	private long rid;
    private long addCount;
    private GameEvent gameEvent;
    private long curr;
}
