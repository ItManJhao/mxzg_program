package com.ayjs.mxzg.common.persistence.hook;

/**
 * 钩住时机
 */
public enum HookOpportunity {

    /**
     * 创建时初始化
     */
    INITIALIZE,

    /**
     * get之后
     */
    GET_AFTER,

    /**
     * 落地之前
     */
    FLUSH_BEFORE,
}
