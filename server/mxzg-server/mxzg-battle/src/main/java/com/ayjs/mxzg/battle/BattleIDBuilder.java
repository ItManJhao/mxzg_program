package com.ayjs.mxzg.battle;

import java.time.LocalDateTime;
import java.util.concurrent.atomic.AtomicInteger;

import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.common.util.time.DateTimeFormatters;

/**
 * 战场id生成器
 * @author meiyc
 *
 */
public class BattleIDBuilder {

	private static AtomicInteger id = new AtomicInteger(1);
	
	/**
	 * 获取新的战场id
	 * @return
	 */
	public static String getNewBattleId(String serverId, BattleType type){
		LocalDateTime localDateTime = LocalDateTime.now();
		String dataTime = localDateTime.format(DateTimeFormatters.FORMATTER_YYYYMMDDHHMMSS);
		return String.format("%s_%s_%s_%s", dataTime, serverId, type, id.getAndIncrement());
	}
	
}
