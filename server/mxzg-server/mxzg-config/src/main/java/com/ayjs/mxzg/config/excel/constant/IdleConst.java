/**
 *
 */
package com.ayjs.mxzg.config.excel.constant;

import java.util.Map;

import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CSystem;

/**
 *
 */
public class IdleConst {
    /**
     * 单次挂机收益时长上限的初始值
     */
    public static int MAX_TIME = 21600;
    /**
     * 快速战斗所收获的时间长度收益（秒）
     */
    public static int SPEED_UP = 7200;
    /**
     * 主线掉落判定（每多少秒判定一次）
     */
    public static int DROP_FREQUENCY = 60;
    /**
     * 创号默认已有挂机时间
     */
    public static int INITIAL_TIME = 60;
    /**
     * 挂机掉落最大掉落限制重置，挂机掉落重置时间
     */
    public static int DROPS_MAX_RESET_TIME = 43200;

    /**
     * 世界等级增益开启的个人等级要求
     */
    public static int WORLD_GAIN_LEVEL = 70;

    public static void loadConst(Map<String, CSystem> nameMap) {
        MAX_TIME = SystemSysCache.parseInt0(nameMap, "idle_max_time");
        SPEED_UP = SystemSysCache.parseInt0(nameMap, "idle_speed_up");
        DROP_FREQUENCY = SystemSysCache.parseInt0(nameMap, "idle_drop_frequency");
        INITIAL_TIME = SystemSysCache.parseInt0(nameMap, "idle_initial_time");
        DROPS_MAX_RESET_TIME = SystemSysCache.parseInt0(nameMap, "idle_drops_max_reset_time");
        WORLD_GAIN_LEVEL = SystemSysCache.parseInt0(nameMap, "world_gain_level");
    }
}
