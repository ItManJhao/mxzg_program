/**
 * 
 */
package com.ayjs.mxzg.config.excel.constant;

import java.util.Map;

import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CSystem;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;

/**
 *
 */
public class BlessingConst {
	
	/**
	 * 普通许愿池刷新价格（钻石）
	 */
	public static int NORMAL_REFRESH_COST_GEM = 30;
	/**
	 * 普通许愿池每次抽奖获得的额外道具
	 */
	public static ImmutableList<ImmutableThing> NORMAL_GAIN_ITEM_EACH_PLAY;
	/**
	 * 普通许愿池每天免费刷新次数（0点刷新）
	 */
	public static int NORMAL_DAILY_FREE_TIMES = 1;
	/**
	 * 高级许愿池刷新价格（钻石）
	 */
	public static int ADVANCE_REFRESH_COST_GEM = 30;
	/**
	 * 高级许愿池每次抽奖获得的额外道具
	 */
	public static ImmutableList<ImmutableThing> ADVANCE_GAIN_ITEM_EACH_PLAY;	
	/**
	 * 高级许愿池每天免费刷新次数（0点刷新）
	 */
	public static int ADVANCE_DAILY_FREE_TIMES = 1;
	
	
	public static void loadConst(Map<String, CSystem> nameMap) {
		NORMAL_DAILY_FREE_TIMES = SystemSysCache.parseInt0(nameMap, "blessing_pool_normal_daily_free_times");
		NORMAL_REFRESH_COST_GEM = SystemSysCache.parseInt0(nameMap, "wishpool_normal_refresh_cost_gem");
		NORMAL_GAIN_ITEM_EACH_PLAY = ImmutableThingUtil.fromJson(nameMap.get("wishpool_normal_gain_item_each_play").getValue());
		ADVANCE_DAILY_FREE_TIMES = SystemSysCache.parseInt0(nameMap, "blessing_pool_advance_daily_free_times");
		ADVANCE_REFRESH_COST_GEM = SystemSysCache.parseInt0(nameMap, "wishpool_advance_refresh_cost_gem");
		ADVANCE_GAIN_ITEM_EACH_PLAY = ImmutableThingUtil.fromJson(nameMap.get("wishpool_advance_gain_item_each_play").getValue());
	}

}
