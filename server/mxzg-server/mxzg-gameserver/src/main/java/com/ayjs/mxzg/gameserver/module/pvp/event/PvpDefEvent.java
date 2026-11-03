/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.pvp.event;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class PvpDefEvent {
	private long rid;
	private int score;
}
