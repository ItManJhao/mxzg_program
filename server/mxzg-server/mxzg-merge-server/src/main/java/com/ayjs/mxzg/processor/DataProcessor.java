package com.ayjs.mxzg.processor;

import com.ayjs.mxzg.common.persistence.AbstractEntity;

/**
 * @Author: CWJ
 * @Date: 2020/8/19
 **/
public interface DataProcessor {

    ProcessorType getType();

    /***
     * 合服前处理
     */
    void beforeMerge(Class<? extends AbstractEntity> clz, String source);

    /**
     * 合服后处理
     */
    void afterMerge(Class<? extends AbstractEntity> clz, String source);

}
