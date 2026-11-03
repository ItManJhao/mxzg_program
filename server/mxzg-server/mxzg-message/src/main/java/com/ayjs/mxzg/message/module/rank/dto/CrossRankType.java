package com.ayjs.mxzg.message.module.rank.dto;

/**
 * @Author: CWJ
 * @Date: 2020/7/12
 **/
public enum CrossRankType {
    /**
     * 公会世界BOSS角色积分排行
     */
    CLAN_WORLD_BOSS_ROLE(10, 9999),
    /**
     * 公会世界BOSS公会积分排行
     */
    CLAN_WORLD_BOSS_CLAN(11, 9999),
    /***
     * 跨服战力
     */
    CROSS_FIGHTING(13, 100),
    /***
     * 跨服公会
     */
    CROSS_CLAN(14, 100),

    CROSS_TEAM_ARENA(16, 999),

    /***
     * 浮空岛
     */
    FLOATING_ISLANDS(17, 500),
    /**
     * 时空魔塔
     */
    TIME_TOWER(19, 1000),

    /**
     * 讨伐团神兵精华排行
     */
    CRUGROUP_ITEM(20, 5000),

    /**
     * 讨伐团玩家神兵精华排行
     */
    CRUGROUP_ITEMP(21, 100),

    /**
     * 讨伐团boss伤害排行
     */
    CRUGROUP_HURT(22, 5000),

    /**
     * 讨伐团玩家boss伤害排行
     */
    CRUGROUP_HURTP(23, 100),

    /**
     * 冥域魔都排行榜-赫卡忒地狱
     */
    HADES_TYPE_1(24, 100),

    /**
     * 冥域魔都排行榜-撒旦魔域
     */
    HADES_TYPE_2(25, 100),
    /**
     * 送花次数排行榜
     */
    PROMOTION_092_COUNT(26, 20),
    /**
     * 英雄积分排行榜
     */
    PROMOTION_092_HERO_SCORE(27, 20),

    /***
     * 积分榜
     */
    COUNTRY_WAR_SCORE(28, 4),
    /***
     * 英雄榜
     */
    COUNTRY_WAR_HERO(29, 30),
    /***
     * 击杀榜
     */
    COUNTRY_WAR_KILL(30, 30),
    /***
     * 伤害榜
     */
    COUNTRY_WAR_DAMAGE(31, 30),

    /***
     * 幻魔塔关卡榜
     */
    MAGIC_TOWER_LEVEL(32, 100),

    /***
     * 幻魔塔擂台榜
     */
    MAGIC_TOWER_ARENA(33, 1),

    ;
    private int type;
    /**
     * 排行榜数量
     */
    private int rankCount;

    CrossRankType(int type, int rankCount) {
        this.type = type;
        this.rankCount = rankCount;
    }

    public static CrossRankType typeOf(int type) {
        for (CrossRankType rankType : CrossRankType.values()) {
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
}
