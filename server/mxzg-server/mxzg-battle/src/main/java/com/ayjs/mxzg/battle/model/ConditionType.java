package com.ayjs.mxzg.battle.model;

/**
 * 条件类型
 */
public enum ConditionType {

    /**
     * 回合数
     * value1:大于指定的回合数则结束战斗(闭区间)
     */
    ROUND,

    /**
     * 死亡英雄数
     * value1:数量，死亡数量大于等于指定的英雄数量时失败
     */
    DEATH_HERO,

    /**
     * 总血量比例
     * value1:低于指定血量比例则结束战斗(万分比)
     */
    BLOOD_VOLUME_RATIO,

}
