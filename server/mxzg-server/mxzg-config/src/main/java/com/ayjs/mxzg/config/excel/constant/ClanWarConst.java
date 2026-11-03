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
public class ClanWarConst {

	/**
	 * 公会战：离线少于多少天内视为活跃人数
	 */
	public static int ACTIVE_STANDARD = 3;
	/**
	 * 公会战在开服N天后开启第一轮
	 */
	public static int OPEN_DAY = 1;
	
	public static void loadConst(Map<String, CSystem> nameMap) {
		ACTIVE_STANDARD = SystemSysCache.parseInt0(nameMap, "clan_war_active_standard");
		OPEN_DAY = SystemSysCache.parseInt0(nameMap, "clan_war_open_day");
	}
}
