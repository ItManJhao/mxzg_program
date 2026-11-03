package com.ayjs.mxzg.processor;

/**
 * @Author: CWJ
 * @Date: 2020/8/19
 **/
public enum ProcessorType {

    /***
     * 数据不处理，直接合并
     */
    NONE("合并数据", true),

    /***
     * role 处理
     */
    ROLE("角色名字处理", true),
    /***
     * clan 处理
     */
    CLAN("公会名字处理", true),
    /***
     * 保留主服数据，其他清除所有数据
     */
    RESERVE_SOURCE("保留主服", false),

    /***
     * 所有服都清除数据
     */
    TRUNCATE_ALL("所有服都清除数据", false),

    /***
     * 爬塔日志处理
     */
    TOWER_LOG("爬塔日志处理", false),

    /***
     * 移除主键为0的对象,合并所有分服
     */
    REMOVE_ZERO("合并数据", true),

    /***
     * 英雄殿堂处理
     */
    HERO_PALACE("英雄殿堂处理", false),
    RAINBOW_SLOT("彩虹神殿处理", false),
    SPACE_TIME_INFO("时空冒险处理", true),
    ;

    private String context;
    /***
     * 表数据是否合并到主服
     */
    private boolean mergeToSource;

    ProcessorType(String context, boolean mergeToSource) {
        this.context = context;
        this.mergeToSource = mergeToSource;
    }

    public boolean isMergeToSource() {
        return mergeToSource;
    }

    public String getContext() {
        return context;
    }
}
