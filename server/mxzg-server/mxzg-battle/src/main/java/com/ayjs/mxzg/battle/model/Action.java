package com.ayjs.mxzg.battle.model;

import lombok.Value;

/**
 * 行动
 */
@Value(staticConstructor = "of")
public class Action {

    /** 反击目标 */
    private HeroDo counterattackTarget;
    /** 反击技能 */
    private SkillDo counterattackSkill;
    /** 效果比例 */
    private long effectPercent;

}
