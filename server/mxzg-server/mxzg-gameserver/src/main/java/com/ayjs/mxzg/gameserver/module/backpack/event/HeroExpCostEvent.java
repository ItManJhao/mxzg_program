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
public class HeroExpCostEvent {
	private long rid;
    private long costCount;
    private GameEvent gameEvent;
    private long curr;
}
