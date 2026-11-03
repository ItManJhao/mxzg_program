/**
 * 
 */
package com.ayjs.mxzg.module.pinnacle;

import com.ayjs.mxzg.config.struct.GameEvent;
import lombok.Value;


@Value(staticConstructor = "of")
public class PinnacleGuessEvent {
	private long rid;
	private long delta;
	private long curr;
	private int guessType;
	private IPinnacleBattle battle;
	private GameEvent gameEvent;
}
