package com.ayjs.mxzg.common.persistence.hook;

@Hook(opportunity = HookOpportunity.INITIALIZE)
public interface DomainInitialization {

    /**
     * 初始化
     */
    default void initialize() {
    }
}
