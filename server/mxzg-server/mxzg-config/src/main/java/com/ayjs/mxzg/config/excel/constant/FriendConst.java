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
public class FriendConst {
	/**
	 * 好友送礼次数上限
	 */
	public static int REWARD_SEND_LIMIT = 100;
	/**
	 * 主动赠送好友礼物时获得的奖励
	 */
	public static ImmutableList<ImmutableThing> GIFT_SEND_REWARD;
	/**
	 * 好友收礼的满额奖励次数上限
	 */
	public static int REWARD_RECEIVE_LIMIT = 10;
	/**
	 * 好友收礼未超出上限时获得的奖励
	 */
	public static ImmutableList<ImmutableThing> GIFT_RECEIVE_REWARD;
	/**
	 * 好友收礼超出上限时获得的奖励
	 */
	public static ImmutableList<ImmutableThing> GIFT_RECEIVE_OVER_REWARD;
	/**
	 * 推荐好友的上限
	 */
	public static int RECOMMEND_COUNT = 10;
	/**
	 * 好友数量上限
	 */
	public static int GLOBAL_FRIEND_MAX = 100;
	
	public static void loadConst(Map<String, CSystem> nameMap) {
		REWARD_SEND_LIMIT = SystemSysCache.parseInt0(nameMap, "friend_reward_send_limit");
		GIFT_SEND_REWARD = ImmutableThingUtil.fromJson(nameMap.get("friend_gift_send_reward").getValue());
		REWARD_RECEIVE_LIMIT = SystemSysCache.parseInt0(nameMap, "friend_reward_receive_limit");
		GIFT_RECEIVE_REWARD = ImmutableThingUtil.fromJson(nameMap.get("friend_gift_receive_reward").getValue());
		GIFT_RECEIVE_OVER_REWARD = ImmutableThingUtil.fromJson(nameMap.get("friend_gift_receive_over_reward").getValue());
		RECOMMEND_COUNT = SystemSysCache.parseInt0(nameMap, "friend_recommend_count");
		GLOBAL_FRIEND_MAX = SystemSysCache.parseInt0(nameMap,"global_friend_max");
	}
}
