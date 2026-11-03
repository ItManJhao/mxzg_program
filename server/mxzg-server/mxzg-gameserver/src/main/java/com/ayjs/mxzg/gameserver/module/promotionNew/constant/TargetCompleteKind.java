package com.ayjs.mxzg.gameserver.module.promotionNew.constant;

/**
 * @Author: CWJ
 * @Date: 2019/10/24
 **/
public enum TargetCompleteKind {
    /**任务*/
    TASK(1),
    /**购买*/
    BUY(2)
    ;
    private int kind;

    TargetCompleteKind(int kind) {
        this.kind = kind;
    }

    public int getKind() {
        return kind;
    }

    public TargetCompleteKind getEnumKind(int kind) {
        for (TargetCompleteKind value : TargetCompleteKind.values()) {
            if (value.getKind() == kind) {
                return value;
            }
        }
        throw new RuntimeException("不存在该类型，kind:" + kind);
    }
}
