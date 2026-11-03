/**
 * 
 */
package com.ayjs.mxzg.config.excel.constant;

import java.util.Map;

import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CSystem;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.google.common.collect.ImmutableList;

/**
 * @author YY
 *
 */
public class PvpConst {
	/**
     * 竞技场对手随机数量
     */
    public static int RANDOM_COUNT = 3;
    /**
     * 竞技场前N次挑战对手为机器人
     */
    public static int CHALLENGE_ROBOT_COUNT = 5;
    /**
     * 竞技场对战记录最大保存条数
     */
    public static int RECORD_MAX_COUNT = 20;
    /**
     * 竞技场门票钻石售价
     */
    public static int TICKET_COST_GEM = 20;
    /**
     * 竞技场每天前N次免门票
     */
    public static int DAILY_FREE_PLAY = 3;
    /**
     * 竞技场赛季结算降积分计算因素，万分比，a_b_c
     */
    public static Integer[] CUP_REDUCE_FACTOR;
    /**
     * 寻找对手的个数
     */
    public static int FIND_COUNT = 10;
    /**
     * 寻找对手的排名分割线
     */
    public static int LOW_RANK = 32;
    /**
     * 竞技场排行榜点赞奖励
     */
    public static ImmutableList<ImmutableThing> LIKE_REWARD;
    /**
     * 竞技场排行榜点赞次数上限
     */
    public static int LIKE_TIMES_DAILY = 10;
    
    public static void loadConst(Map<String, CSystem> nameMap) {
    	DAILY_FREE_PLAY = SystemSysCache.parseInt0(nameMap, "pvp_daily_free_play");
    	TICKET_COST_GEM = SystemSysCache.parseInt0(nameMap, "pvp_ticket_cost_gem");
    	RANDOM_COUNT = SystemSysCache.parseInt0(nameMap, "pvp_random_count");
        CHALLENGE_ROBOT_COUNT = SystemSysCache.parseInt0(nameMap, "pvp_challenge_robot_count");
        RECORD_MAX_COUNT = SystemSysCache.parseInt0(nameMap, "pvp_record_max_count");
        String pvpCupReduceFactorStr = nameMap.get("pvp_cup_reduce_factor").getValue();
        CUP_REDUCE_FACTOR = StringUtil.stringToArray(pvpCupReduceFactorStr, "_", Integer.class);
        LIKE_REWARD = ImmutableThingUtil.fromJson(nameMap.get("pvp_like_reward").getValue());
        LIKE_TIMES_DAILY = SystemSysCache.parseInt0(nameMap, "pvp_like_times_daily");
    }
}
