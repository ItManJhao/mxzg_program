package com.ayjs.mxzg.common.lifecycle;

/**
 * 存活周期
 */
public interface Lifecycle {

    /**
     * 生命周期信息
     */
    LifecycleInfo getInfo();

    /**
     * 游戏起服时执行
     */
    default void start() throws Exception {
    }

    /**
     * 停服之前调用
     */
    default void stop() throws Exception {
    }

}
