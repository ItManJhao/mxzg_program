package com.ayjs.mxzg.common.command;

/**
 * 指令接口,
 * @author meiyc
 *
 */
public interface Command {

    /**
     * 指令调用完成之后调用该接口
     */
    default void mergeResult(){};

    /**
     * 每执行一次接受者修改调用一次
     */
    default void peek(){};
}
