/**
 * 
 */
package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CSystem;

import java.util.Map;

/**
 * @author YY
 *
 */
public class TowerConst {

	/**
	 * 环境之塔门票上限
	 */
	public static int TICKETS_LIMIT = 20;
	/**
	 * 环境之塔门票恢复时间
	 */
	public static int TICKETS_REGENERATE_TIME = 1800;
	/**
	 * 环境之塔购买门票消耗钻石
	 */
	public static int TICKETS_GEM_COST = 20;

	/** 语言表基础id 第几层 */
	public static int LANGUAGE_STAGE_ID = 991000001;
	
	/**
	 * 时空魔塔语言ID
	 */
	public static int TIME_TOWER_LANGUAGE_ID = 54505;

	public static void loadConst(Map<String, CSystem> nameMap) {
		TICKETS_LIMIT = SystemSysCache.parseInt0(nameMap, "tower_tickets_limit");
		TICKETS_REGENERATE_TIME = SystemSysCache.parseInt0(nameMap, "tower_tickets_regenerate_time");
		TICKETS_GEM_COST = SystemSysCache.parseInt0(nameMap, "tower_tickets_gem_cost");
	}
}
