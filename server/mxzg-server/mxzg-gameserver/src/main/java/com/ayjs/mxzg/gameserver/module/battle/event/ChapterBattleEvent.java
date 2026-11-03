/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.battle.event;

import lombok.Value;

/**
 * @author YY
 * 关卡挑战事件
 */
@Value(staticConstructor = "of")
public class ChapterBattleEvent {
	private long rid;
	private int missionId;
	private int fighting;
	private int level;
	private boolean isWin;
}
