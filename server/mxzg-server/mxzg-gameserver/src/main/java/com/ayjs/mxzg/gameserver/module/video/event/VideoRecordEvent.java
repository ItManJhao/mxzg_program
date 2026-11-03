/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.video.event;

import com.ayjs.mxzg.gameserver.module.video.constant.VideoType;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class VideoRecordEvent {
	private VideoType videoType;
	
	private int subType;
	
	private BattleReport battleReport;
	
	private String testValue;
}
