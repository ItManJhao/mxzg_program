package com.ayjs.mxzg.battle.model;

import com.google.common.collect.Sets;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * 额外行动信息，例如反击/追击/连击
 *
 */
public class ActionInfo {

    /** 当前是否是反击/连击 */
    private boolean counterattack;
    /** 行动列表 */
    private List<Action> actionList = new ArrayList<>();

    public static ActionInfo getInstance(){
        return new ActionInfo();
    }

    /**
     * 清空反击目标
     */
    public void cleanCounterattack(AttributeInfo attributeInfo){
        if(counterattack){
            this.actionList.remove(0);
            attributeInfo.cleanEffect();
        }
        this.counterattack = false;
    }

    /**
     * 添加行动
     * @param attackTarget
     * @param skillDo
     * @param effectPercent
     */
    public void addAction(HeroDo attackTarget, SkillDo skillDo, long effectPercent){
        Action action = Action.of(attackTarget, skillDo, effectPercent);
        this.actionList.add(action);
    }

    /**
     * 设置下一回合是否是反击或连击
     */
    public void setCounterattack(){
        this.counterattack = true;
    }

    /**
     * 下次行动技能
     * @return
     */
    public boolean hasNextAction(){
        return !this.actionList.isEmpty();
    }

    /**
     * 下次行动技能
     * @return
     */
    public SkillDo nextActionSkill(){
        return getNextAction().getCounterattackSkill();
    }

    /**
     * 是否已经存在该动作
     * @param skillDo
     * @return
     */
    public boolean isExistActionSkill(SkillDo skillDo){
        return this.actionList.stream().anyMatch(action -> action.getCounterattackSkill() == skillDo);
    }

    /**
     * 有目标则返回反击目标，没有则返回null
     * @return
     */
    public Set<HeroDo> getActionTargets(){
        if(actionList.isEmpty()){
            return null;
        } else {
            Action action = this.actionList.get(0);
            if(action.getCounterattackTarget() == null){
                return null;
            }
            Set<HeroDo> targets = Sets.newLinkedHashSet();
            targets.add(action.getCounterattackTarget());
            return targets;
        }
    }

    /**
     * 是否是反击/追击
     * @return
     */
    public boolean isCounterattack(){
        return this.counterattack;
    }

    /**
     * 获取下一次行动
     * @return
     */
    public Action getNextAction(){
        if (CollectionUtils.isEmpty(this.actionList)) {
            return null;
        }
        return this.actionList.get(0);
    }

    /**
     * 是否是普攻反击，如果是则不重新选择目标，否则重新选择目标
     * @return
     */
    public boolean isGeneralCounterattack(SkillDo generalSkill){
        if(!isCounterattack()){
            return false;
        }
        return getNextAction().getCounterattackSkill() == generalSkill;
    }

}
