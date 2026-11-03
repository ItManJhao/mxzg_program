package com.ayjs.mxzg.config.struct;

import java.util.HashMap;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
public enum GodRelicTargetType {

    /***
     * 战斗胜利
     */
    PASS(1),

    /***
     * 每个英雄血量比率在多少以上
     *
     * 参数1：比率（百分数）
     */
    HP_RATE_MORE(2),

    /**
     * 英雄存活
     * 参数1：存活数量0代表上阵所有英雄
     */
    HERO_ALIVE_MORE(3),

    /***
     * 战斗回合不超过
     * 参数1：回合数
     */
    ROUND_LESS(4),

    /***
     * 最少上阵特定属性的数量
     * 参数1：属性
     * 参数2：数量
     */
    ELEMENT_NUM_MORE(5),

    /***
     * 最少上阵特定职业的数量
     * 参数1：职业
     * 参数2：数量
     */
    JOB_NUM_MORE(6),

    /***
     * 最多上阵特定属性的数量
     * 参数1：属性
     * 参数2：数量
     */
    ELEMENT_NUM_LESS(7),

    /***
     * 最多上阵特定职业的数量
     * 参数1：职业
     * 参数2：数量
     */
    JOB_NUM_LESS(8),

    /***
     * 使用锲约
     * 参数1：契约类型
     */
    BATTLE_MATRIX(9),

    ;

    private int type;

    GodRelicTargetType(int type) {
        this.type = type;
    }

    public int getType() {
        return type;
    }


    private static Map<Integer, GodRelicTargetType> map = null;

    static {
        Map<Integer, GodRelicTargetType> map_ = new HashMap<>();
        for (GodRelicTargetType targetType : GodRelicTargetType.values()) {
            map_.put(targetType.getType(), targetType);
        }
        map = map_;
    }

    public GodRelicTargetType getEnumType(int type) {
        return map.get(type);
    }
}
