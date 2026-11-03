package com.ayjs.mxzg.gameserver.module.rank.constant;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
 **/
public enum RankType {

    /**
     * 战力
     */
    FIGTH_ING(1, 100, false),
    /**
     * 竞技场，冠军赛需要128名玩家，因此排名必须大于128
     */
    ARENA(2, 200, false),
    /**
     * 商会
     */
    CLAN(3, 100, false),
    /**
     * 幻境
     */
    TOWER(4, 100, false),
    /**
     * 地牢
     */
    DUNGEON(5, 100, false),
    /**
     * 点石成金
     */
    BUY_GOLD(6, 200, false),
    /**
     * 速战之王
     */
    SPEED_FIGHT(7, 200, false),
    /**
     * 试炼之路
     */
    ADVENTURE(8, 200, false),
    /**
     * 酒馆常客
     */
    TAVERN(9, 200, false),
    /**
     * 公会世界BOSS角色积分排行
     */
    CLAN_WORLD_BOSS_ROLE(10, 9999, false),
    /**
     * 公会世界BOSS公会积分排行
     */
    CLAN_WORLD_BOSS_CLAN(11, 9999, false),
    /**
     * 永恒梦境排行榜
     */
    DREAMLAND(12, 100, false),
    /***
     * 跨服战力
     */
    CROSS_FIGHTING(13, 100, true),
    /***
     * 跨服公会
     */
    CROSS_CLAN(14, 100, true),

    /***
     * 主线榜
     */
    ROLE_MISSION(15, 100, false),

    /***
     * 组队竞技场
     */
    TEAM_ARENA(16, 999, true),

    /***
     * 浮空岛
     */
    FLOATING_ISLANDS(17, 500, true),

    /***
     * 诸神遗迹
     */
    GOD_RELIC(18, 100, false),

    /***
     * 位面之战
     */
    PLANE_WAR(19, 100, false),
    //
    /**
     * 讨伐团神兵精华排行
     */
    CRUGROUP_ITEM(20, 5000, true),

    /**
     * 讨伐团玩家神兵精华排行
     */
    CRUGROUP_ITEMP(21, 100, true),

    /**
     * 讨伐团boss伤害排行
     */
    CRUGROUP_HURT(22, 5000, true),

    /**
     * 讨伐团玩家boss伤害排行
     */
    CRUGROUP_HURTP(23, 100, true),

    /**
     * 冥域魔都排行榜-赫卡忒地狱
     */
    HADES_TYPE_1(24, 100, true),

    /**
     * 冥域魔都排行榜-撒旦魔域
     */
    HADES_TYPE_2(25, 100, true),

    /**
     * 送花次数排行榜
     */
    PROMOTION_092_COUNT(26, 20, true),
    /**
     * 英雄积分排行榜
     */
    PROMOTION_092_HERO_SCORE(27, 20, true),

    /***
     * 积分榜
     */
    COUNTRY_WAR_SCORE(28, 4, true),
    /***
     * 英雄榜
     */
    COUNTRY_WAR_HERO(29, 30, true),
    /***
     * 击杀榜
     */
    COUNTRY_WAR_KILL(30, 30, true),
    /***
     * 伤害榜
     */
    COUNTRY_WAR_DAMAGE(31, 30, true),
    ;

    private int type;
    /**
     * 排行榜数量
     */
    private int rankCount;

    private boolean isCross;

    RankType(int type, int rankCount, boolean isCross) {
        this.type = type;
        this.rankCount = rankCount;
        this.isCross = isCross;
    }

    public static RankType typeOf(int type) {
        for (RankType rankType : RankType.values()) {
            if (rankType.getType() == type) {
                return rankType;
            }
        }
        throw new RuntimeException("不存在该类新排行榜：" + type);
    }

    public int getType() {
        return type;
    }

    public int getRankCount() {
        return rankCount;
    }

    public boolean isCross() {
        return isCross;
    }
}
