/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.rainbow.event;

import com.ayjs.mxzg.gameserver.module.rainbow.domain.RainbowSlot;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class RainbowChallengeEvent {
	private long rid;
	private RainbowSlot newSlot;
	private RainbowSlot oldSlot;
	//原先占据神位的玩家ID
	private long oldRid;
}
