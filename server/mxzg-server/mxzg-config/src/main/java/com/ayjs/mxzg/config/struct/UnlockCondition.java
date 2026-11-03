package com.ayjs.mxzg.config.struct;

import java.util.Set;

import lombok.Getter;
import lombok.Setter;


/**
 * 阵法解锁类型
 */
@Getter
@Setter
public class UnlockCondition implements Condition {

    /** 英雄类型 */
    private Set<Integer> type;

    /** 星级 */
    private int star;

    /** 数量 */
    private int target;

    /**
     * 检测条件是否满足
     * @param star
     * @param element
     * @return
     */
    @Override
    public boolean check(int star, int element){
        return type.contains(element) && star >= this.star;
    }

    /**
     * 是否
     * @param targetNum
     * @return
     */
    @Override
    public boolean isFinish(int targetNum){
        return targetNum >= this.target;
    }
}
