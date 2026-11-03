package com.ayjs.mxzg.common.lifecycle;

/**
 * 系统生命周期级别
 */
public enum Priority {
    /**
     * 系统初始化最先执行
     */
    INITIALIZATION(0),

    /**
     * 系统级
     */
    SYSTEM(100),

    /**
     * 高优先级
     */
    HIGH(200),

    /**
     * 中等优先级 - 业务级别默认
     */
    MEDIUM(300),

    /**
     * 优先级低
     */
    LOW(400),
    ;

    private final int priority;

    Priority(int priority) {
        this.priority = priority;
    }

    public int getPriority() {
        return priority;
    }
}
