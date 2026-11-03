package com.ayjs.mxzg.gameserver.module.server.constant;

public enum ServerParamType {
    /**
     * 测试
     */
    TEST(1),
    /**
     * 开服时间
     */
    OPEN_SERVER_TIME(2),
    /**
     * 地牢开启时间
     */
    SHELTER_START_TIME(4),

    /***
     * 维护结束时间
     */
    DEFEND_END_TIME(5),
    /***
     * 发送角色去跨服
     */
    SEND_ALL_ROLE_TO_CROSS(6),

    /***
     * 跨服服务器上传
     */
    CROSS_CLAN_SEND(7),
    /**
     * 英雄分享未删id集
     */
    HERO_SHARE_REDIS_ID_LIST(8),
    /**
     * 永恒梦境排行榜奖励时间
     */
    DREAMLAND_RANK_REWARD_TIME(9),

    /**
     * 天梯排行榜时间
     */
    LADDER_TIMER(10),

    /**
     * 数据修复
     */
    REPAIR_DATA(11),

    /**
     * 组队竞技场
     */
    TEAM_ARENA(12),

    /**
     * 合服补偿
     */
    MERGE_COMPENSATE(13),
    /**
     * 充值等级限制
     */
    RECHARGE_LEVEL_INFO(14),

    ;

    private final int value;

    ServerParamType(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
