package com.ayjs.mxzg.config.struct;

/**
 * 神职特权类型
 * @author hyx
 */
public enum ClergyPrivilegeType {

    /**
     * 金币副本
     */
    GOLD_DUNGEON(1),

    /**
     * 经验副本
     */
    EXP_DUNGEON(2),

    /**
     * 英雄副本
     */
    HERO_DUNGEON(3),

    /**
     * 羁绊副本
     */
    FETTER_DUNGEON(4),

    /**
     * 精灵副本特权
     */
    RUNE_DUNGEON(5),

    /**
     * 竞技场挑战特权
     */
    PVP(6),

    /**
     * 主线挂机收益加成特权
     */
    IDLE_AWARD(7),

    /**
     * 积分召唤
     */
    POINT_SUMMON(8),

    /**
     * 黑市特权
     */
    STALL_SHOP(9),

    ;

    private int type;

    ClergyPrivilegeType(int type){
        this.type = type;
    }

    public int getType() {
        return type;
    }

}
