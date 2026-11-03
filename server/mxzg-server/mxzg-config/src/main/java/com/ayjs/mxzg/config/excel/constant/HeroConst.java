/**
 *
 */
package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CSystem;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;

import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * @author YY
 *
 */
public class HeroConst {
    /**
     * 战斗力计算倍数
     */
    public static int FIGHT_MUL = 3;
    /**
     * 高10连抽必出5星的保底次数
     */
    public static int ADV_SUMMON_GUARANTEE_TIME = 20;
    /**
     * 积分召唤所需的点数
     */
    public static int POINT_SUMMON_RECHARGE_NEED = 100;
    /**
     * 高抽多少次必定获得1次T1英雄
     */
    public static int ADV_SUMMON_T1_GUARANTEE_TIMES = 60;
    /**
     * 获得T1英雄的奖池id
     */
    public static int ADV_SUMMON_T1_GUARANTEE_REWARD_GROUP = 1021;
    /**
     * 高抽保底的奖池id
     */
    public static int ADV_SUMMON_GUARANTEE_REWARD_GROUP = 1022;
    /**
     * 新手初次十连的奖池id
     */
    public static int FIRST_ADV_SUMMON_GUARANTEE_REWARD_GROUP = 1023;

    /**
     * 英雄回退的星级
     */
    public static int HERO_COME_BACK_STAR = 9;
    /**
     * 英雄只置换的目标最小配置表星级
     */
    public static int HERO_SWITCH_TARGET_MIN_STAR = 10;
    /**
     * 英雄置换素材的星级
     */
    public static int HERO_SWITCH_MATERIAL_STAR = 5;

    public static List<ImmutableThing> ADV_SUMMON_10_FIXED_PRIZE = Collections.emptyList();

    /**
     * 英雄祈愿最大值
     */
    public static int ADV_SUMMON_WISH_TIME = 20;

    /**
     * 祈愿火系奖励id
     */
    public static int ADV_WISH_FIRE_REWARD_TYPE = 1051;

    /**
     * 祈愿水系奖励id
     */
    public static int ADV_WISH_WATER_REWARD_TYPE = 1052;

    /**
     * 祈愿草系奖励id
     */
    public static int ADV_WISH_WOOD_REWARD_TYPE = 1053;

    /**
     * 挂机最大英雄数，写死
     */
    public static final int LANG_UP_MAX_HERO_NUM = 3;

    /**
     * 天赋解锁星级
     */
    public static Map<Integer, Integer> TALENT_STAR;
    /**
     * 新英雄抽卡多少次必出新英雄
     */
    public static int[] NHA_NEWHERO_MUSTOUT = new int[]{120, 150, 180, 210};
    /**
     * 新英雄抽卡必出新英雄奖池
     */
    public static int NHA_NEWHERO_GROUP = 1021;
    /**
     * 新英雄活动n次没5星后必出5星的保底次数
     */
    public static int NHA_MUSTOUT_FIVESTAR_TIMES = 10;
    /**
     * 高抽保底的奖池id
     */
    public static int NHA_MUSTOUT_FIVESTAR_GROUP = 1022;

    /**
     * 十连新英雄活动需要补专属抽奖券时候的单价
     */
    public static List<ImmutableThing> NHA_10_FIXED_PRIZE = Collections.emptyList();

    public static int[] NEED_STAR_NUM = new int[]{0, 0};
    /**
     * 6星及以下重生星级限制
     */
    public static int HERO_LEVEL_RESET_LIMIT = 6;
    /**
     * 6星及以下等级重生每天免费次数
     */
    public static int HERO_LEVEL_RESET_DAILY_FREE_TIMES = 3;
    /**
     * 6星及以下等级重生消耗
     */
    public static List<ImmutableThing> HERO_LEVEL_RESET_COST = Collections.emptyList();

    public static void loadConst(Map<String, CSystem> nameMap) {
        FIGHT_MUL = SystemSysCache.parseInt0(nameMap, "hero_fight_mul");
        ADV_SUMMON_GUARANTEE_TIME = SystemSysCache.parseInt0(nameMap, "adv_summon_guarantee_times");
        POINT_SUMMON_RECHARGE_NEED = SystemSysCache.parseInt0(nameMap, "point_summon_recharge_need");
        ADV_SUMMON_T1_GUARANTEE_TIMES = SystemSysCache.parseInt0(nameMap, "adv_summon_t1_guarantee_times");
        ADV_SUMMON_T1_GUARANTEE_REWARD_GROUP = SystemSysCache.parseInt0(nameMap, "adv_summon_t1_guarantee_reward_group");
        ADV_SUMMON_GUARANTEE_REWARD_GROUP = SystemSysCache.parseInt0(nameMap, "adv_summon_guarantee_reward_group");
        FIRST_ADV_SUMMON_GUARANTEE_REWARD_GROUP = SystemSysCache.parseInt0(nameMap, "first_adv_summon_guarantee_reward_group");
        ADV_SUMMON_10_FIXED_PRIZE = ImmutableThingUtil.fromJson(nameMap.get("adv_summon_10_fixed_prize").getValue());
        ADV_SUMMON_WISH_TIME = SystemSysCache.parseInt0(nameMap, "adv_summon_wish_time");
        ADV_WISH_FIRE_REWARD_TYPE = SystemSysCache.parseInt0(nameMap, "adv_wish_fire_reward_type");
        ADV_WISH_WATER_REWARD_TYPE = SystemSysCache.parseInt0(nameMap, "adv_wish_water_reward_type");
        ADV_WISH_WOOD_REWARD_TYPE = SystemSysCache.parseInt0(nameMap, "adv_wish_wood_reward_type");

        String talentStr = nameMap.get("talent_unlock_star").getValue();
        TALENT_STAR = StringUtil.stringToMap(talentStr, ";", "_", Integer.class, Integer.class);

        NHA_NEWHERO_MUSTOUT = StringUtil.stringToIntArray(nameMap.get("nha_summon_newhero_mustout").getValue(), "_");
        NHA_NEWHERO_GROUP = SystemSysCache.parseInt0(nameMap, "nha_summon_newhero_group");
        NHA_MUSTOUT_FIVESTAR_TIMES = SystemSysCache.parseInt0(nameMap, "nha_summon_musyout_fivestar_times");
        NHA_MUSTOUT_FIVESTAR_GROUP = SystemSysCache.parseInt0(nameMap, "nha_summon_musyout_fivestar_group");
        NHA_10_FIXED_PRIZE = ImmutableThingUtil.fromJson(nameMap.get("nha_summon_10_fixed_prize").getValue());

        NEED_STAR_NUM = GsonUtils.fromJson(nameMap.get("need_star_num").getValue(), int[].class);

        HERO_LEVEL_RESET_LIMIT = SystemSysCache.parseInt0(nameMap, "hero_level_reset_limit");
        HERO_LEVEL_RESET_DAILY_FREE_TIMES = SystemSysCache.parseInt0(nameMap, "hero_level_reset_daily_free_times");
        HERO_LEVEL_RESET_COST = ImmutableThingUtil.fromJson(nameMap.get("hero_level_reset_cost").getValue());
    }
}
