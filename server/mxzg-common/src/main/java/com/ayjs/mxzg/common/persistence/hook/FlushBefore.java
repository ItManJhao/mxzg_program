package com.ayjs.mxzg.common.persistence.hook;

@Hook(opportunity = HookOpportunity.FLUSH_BEFORE)
public interface FlushBefore {

    /**
     * 入库之前
     *
     * @return 是否有修改
     */
    default boolean flushBefore() {
        return false;
    }
}
