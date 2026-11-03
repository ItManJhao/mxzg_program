package com.ayjs.mxzg.struct;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.processor.ProcessorType;
import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
@Value(staticConstructor = "of")
public class DataProcessorMeta {

    private Class<? extends AbstractEntity> clz;

    private int priority;

    private ProcessorType processorType;

    private String source;

}
