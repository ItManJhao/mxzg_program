package com.ayjs.mxzg.common.base;

/**
 * spring 上下文监听
 */
@FunctionalInterface
public interface ContextListener {
    /**
     * Spring上下文加载完成后调用
     */
    void complete();
}
