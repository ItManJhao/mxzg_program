package com.ayjs.mxzg.config.struct;

/**
 * 解锁条件接口
 */
public interface Condition {

    /**
     * 检测条件是否满足
     * @param star
     * @param element
     * @return
     */
    boolean check(int star, int element);

    /**
     * 是否完成
     * @param targetNum
     * @return
     */
    boolean isFinish(int targetNum);

}
