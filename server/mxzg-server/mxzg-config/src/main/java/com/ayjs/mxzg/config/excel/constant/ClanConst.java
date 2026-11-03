package com.ayjs.mxzg.config.excel.constant;

import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CSystem;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * @author hyx
 */
public class ClanConst {

    /**
     * 公会技能等级最大差距
     */
    public static int CLAN_SKILL_LEVEL_GAP = 15;

    /**
     * 会长不在线转交职位时长
     */
    public static int CLAN_MAKE_OVER_TIME = 604800;

    /**
     * 公会成员活跃玩家
     */
    public static int CLAN_MEMBER_TIME = 259200;


    public static void loadConst(Map<String, CSystem> nameMap) {
        CLAN_SKILL_LEVEL_GAP = SystemSysCache.parseInt0(nameMap, "clan_skill_level_gap");
        CLAN_MAKE_OVER_TIME = SystemSysCache.parseInt0(nameMap, "clan_make_over_time");
        CLAN_MEMBER_TIME = SystemSysCache.parseInt0(nameMap, "clan_member_time");
    }

}
