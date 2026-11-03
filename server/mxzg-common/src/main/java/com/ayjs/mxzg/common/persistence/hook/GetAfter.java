package com.ayjs.mxzg.common.persistence.hook;

@Hook(opportunity = HookOpportunity.GET_AFTER)
public interface GetAfter {

    /**
     * get 之后
     *
     * @return 是否有修改
     */
    default boolean getAfter() {
        return false;
    }
}
