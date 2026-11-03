/**
 *
 */
package com.ayjs.mxzg.config.excel.constant;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.alibaba.fastjson.JSONArray;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CSystem;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;

/**
 * @author YY
 *
 */
public class TavernConst {

	/**
	 * 酒馆刷新消耗钻石数量
	 */
	public static int REFRESH_GEM = 30;
	/**
	 * 酒馆常客活动加成任务数量
	 */
	public static int PROMOTION_PLUS_TIMES = 2;
	/**
	 * 初始默认酒馆任务数量
	 */
	public static int NUM = 5;
	/**
	 * 新号刷新酒馆任务必出任务(shopmarket表的idx)
	 */
	public static int INITIAL_TASK = 267;
	/**
	 * 新号酒馆默认任务
	 */
	public static List<Integer> FIRST_TASK = new ArrayList<>();

	/**
	 * 酒馆常客活动冒险点数打折
	 */
	public static int TAVERN_PROMOTION_DISCOUNT = 9000;

	/**
	 * 酒馆每日免费刷新次数
	 */
	public static int TAVERN_FRESHEN_TIMES = 3;

	/**
	 * 酒馆任务刷新固定消耗道具
	 */
	public static List<ImmutableThing> TAVERN_REFRESH_ITEM = new ArrayList<>();

	/**
	 * 创号默认冒险点数
	 */
	public static int TAVERN_INITIAL_ITEM = 3000;

	/**
	 * 酒馆加速费用单位时间（秒）
	 */
	public static int TAVERN_QUICKEN_TIME = 3600;

	/**
	 * 酒馆加速费用单位时间所需钻石
	 */
	public static int TAVERN_QUICKEN_COST = 10;

	/**
	 * 酒馆加速费用最大费用钻石
	 */
	public static int TAVERN_QUICKEN_COST_MAX = 60;

	public static void loadConst(Map<String, CSystem> nameMap) {
		REFRESH_GEM = SystemSysCache.parseInt0(nameMap, "tavern_refresh_gem");
		PROMOTION_PLUS_TIMES = SystemSysCache.parseInt0(nameMap, "tavern_promotion_plus_times");
		NUM = SystemSysCache.parseInt0(nameMap, "tavern_num");
		INITIAL_TASK = SystemSysCache.parseInt0(nameMap, "tavern_initial_task");
		FIRST_TASK = JSONArray.parseArray(nameMap.get("first_tavern_task").getValue(), Integer.class);
		TAVERN_PROMOTION_DISCOUNT = SystemSysCache.parseInt0(nameMap,"tavern_promotion_discount");
		TAVERN_FRESHEN_TIMES = SystemSysCache.parseInt0(nameMap,"tavern_freshen_times");
		TAVERN_REFRESH_ITEM = ImmutableThingUtil.fromJson(nameMap.get("tavern_refresh_item").getValue());
		TAVERN_INITIAL_ITEM = SystemSysCache.parseInt0(nameMap,"tavern_initial_item");
		TAVERN_QUICKEN_TIME = SystemSysCache.parseInt0(nameMap,"tavern_quicken_time");
		TAVERN_QUICKEN_COST = SystemSysCache.parseInt0(nameMap,"tavern_quicken_cost");
		TAVERN_QUICKEN_COST_MAX = SystemSysCache.parseInt0(nameMap,"tavern_quicken_cost_max");
	}
}
