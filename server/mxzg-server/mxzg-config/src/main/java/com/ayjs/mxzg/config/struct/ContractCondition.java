package com.ayjs.mxzg.config.struct;

import lombok.Getter;
import lombok.Setter;


/**
 * 契约解锁条件
 */
@Getter
@Setter
public class ContractCondition implements Condition {

    /** 英雄类型 */
    private String type;

    /** 数量 */
    private int target;

    /** 星级 */
    private int condition;

    @Override
    public boolean check(int star, int element){
        return star >= condition;
    }

    @Override
    public boolean isFinish(int targetNum){
        return targetNum >= this.target;
    }
}
