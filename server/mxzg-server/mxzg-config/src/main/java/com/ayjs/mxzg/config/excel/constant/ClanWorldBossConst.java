/**
 * 
 */
package com.ayjs.mxzg.config.excel.constant;

import java.util.Map;

import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CSystem;

/**
 * @author YY
 *
 */
public class ClanWorldBossConst {
	/**
	 * 公会世界BOSS伤害积分转化率，100点伤害=1积分
	 */
	public static int DAMAGE_TO_POINT = 100;
	/**
	 * 公会世界BOSS掠夺积分万分比
	 */
	public static int ROB_RATE = 2500;
	/**
	 * 公会世界BOSS查找掠夺列表的浮动范围，上下各取N名
	 */
	public static int SEARCH_RANGE = 3;
	/**
	 * 公会世界BOSS掠夺日志最大条数
	 */
	public static int MAX_RECORD = 30;
	/**
	 * 公会世界BOSS在开服N天后开启第一轮
	 */
	public static int OPEN_DAY = 1;
	
	public static void loadConst(Map<String, CSystem> nameMap) {
		DAMAGE_TO_POINT = SystemSysCache.parseInt0(nameMap, "clan_world_boss_damage_to_point");
        ROB_RATE = SystemSysCache.parseInt0(nameMap, "clan_world_boss_rob_rate");
        SEARCH_RANGE = SystemSysCache.parseInt0(nameMap, "clan_world_boss_search_range");
        MAX_RECORD = SystemSysCache.parseInt0(nameMap, "clan_world_boss_max_record");
        OPEN_DAY = SystemSysCache.parseInt0(nameMap, "clan_world_boss_open_day");
	}
}
