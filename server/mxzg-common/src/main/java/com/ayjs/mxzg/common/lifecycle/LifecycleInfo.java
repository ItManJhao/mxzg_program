package com.ayjs.mxzg.common.lifecycle;

/**
 * 存活周期信息
 */
public class LifecycleInfo {
    /**
     * 生命周期排序值，顺序启动，倒序关闭
     */
    private final int order;
    /**
     * 名称
     */
    private final String name;

    private LifecycleInfo(int order, String name) {
        this.order = order;
        this.name = name;
    }

    public static LifecycleInfo valueOf(String name) {
        return new LifecycleInfo(Priority.MEDIUM.getPriority(), name);
    }

    public static LifecycleInfo valueOf(Priority priority, int ordinal, String name) {
        return new LifecycleInfo(priority.getPriority() + ordinal, name);
    }

    public int getOrder() {
        return order;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return String.format("LifecycleInfo{order=%s,  name=%s}'", order, name);
    }
}
