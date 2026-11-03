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
public class ProphecyConst {
	/**
	 * 先知召唤消耗
	 */
	public static int SUMMON_COST;
	/**
	 * 先知召唤游玩额外获得的道具
	 */
	public static ImmutableList<ImmutableThing> SUMMON_GAIN_ITEM_EACH_PLAY;
	/**
	 * 先知5星置换费用
	 */
	public static ImmutableList<ImmutableThing> EXCHANGE_COST;
	/**
	 * 先知4星置换费用
	 */
	public static ImmutableList<ImmutableThing> EXCHANGE_COST4;

	public static void loadConst(Map<String, CSystem> nameMap) {
		EXCHANGE_COST = ImmutableThingUtil.fromJson(nameMap.get("prophecy_exchange_cost").getValue());
		EXCHANGE_COST4 = ImmutableThingUtil.fromJson(nameMap.get("prophecy_exchange_cost_4").getValue());
		SUMMON_GAIN_ITEM_EACH_PLAY = ImmutableThingUtil.fromJson(nameMap.get("prophecy_summon_gain_item_each_play").getValue());
		SUMMON_COST = SystemSysCache.parseInt0(nameMap, "prophecy_summon_cost");
	}
}
