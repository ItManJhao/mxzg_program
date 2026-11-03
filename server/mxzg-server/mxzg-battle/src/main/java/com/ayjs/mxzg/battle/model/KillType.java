package com.ayjs.mxzg.battle.model;

/**
 * 击杀状态
 * 标记当次技能是否造成击杀，针对多个目标检测但是又只能一次生效的情况
 * 例如毁灭之烬的3技能增加目标之后的情况
 */
public enum KillType {

    /** 还未产生击杀 */
    NOT_KILLED,

    /** 已经产生击杀了，但是还未触发击杀后续逻辑*/
    KILL,

    /** 击杀并已经执行过击杀逻辑 */
    KILLED;
}
