/**
 * 
 */
package com.ayjs.mxzg.largecross.module.towercross.event;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class TimeTowerRankEvent {
	private long rid;
	private int currLayer;
	private int time;
	private int serverId;
}
