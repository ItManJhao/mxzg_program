package com.ayjs.mxzg.processor.impl;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.processor.DataProcessor;
import com.ayjs.mxzg.processor.ProcessorType;

/**
 * @Author: CWJ
 * @Date: 2020/11/11
 **/
public class NoneProcessor implements DataProcessor {
    @Override
    public ProcessorType getType() {
        return ProcessorType.NONE;
    }

    @Override
    public void beforeMerge(Class<? extends AbstractEntity> clz, String source) {

    }

    @Override
    public void afterMerge(Class<? extends AbstractEntity> clz, String source) {

    }
}
