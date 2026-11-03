/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.ladder.event;

import com.ayjs.mxzg.message.module.ladder.message.CrossLadderRank;
import com.google.common.collect.ImmutableList;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class LadderEndEvent {
	private ImmutableList<CrossLadderRank> rankList;
}
