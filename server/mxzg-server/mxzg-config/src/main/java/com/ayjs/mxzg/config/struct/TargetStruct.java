package com.ayjs.mxzg.config.struct;

/**
 * 目标结构体
 *
 * @Author: CWJ
 * @Date: 2019/10/26
 **/
public class TargetStruct {

    private TargetType type;

    private int target;

    private int condition;

    private int subCondition;


    public TargetType getType() {
        return type;
    }

    public void setType(TargetType type) {
        this.type = type;
    }

    public int getTarget() {
        return target;
    }

    public void setTarget(int target) {
        this.target = target;
    }

    public int getCondition() {
        return condition;
    }

    public void setCondition(int condition) {
        this.condition = condition;
    }

    public int getSubCondition() {
        return subCondition;
    }

    public void setSubCondition(int subCondition) {
        this.subCondition = subCondition;
    }

    public static TargetStruct of(TargetType targetType, int condition, int subCondition) {
        TargetStruct targetStruct = new TargetStruct();
        targetStruct.setType(targetType);
        targetStruct.subCondition = subCondition;
        targetStruct.condition = condition;
        return targetStruct;
    }

    public static TargetStruct of(TargetType targetType, int condition) {
        return TargetStruct.of(targetType, condition, 0);
    }

    public static TargetStruct of(TargetType targetType) {
        return TargetStruct.of(targetType, 0, 0);
    }
}
