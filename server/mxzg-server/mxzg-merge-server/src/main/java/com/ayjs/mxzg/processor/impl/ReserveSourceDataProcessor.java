package com.ayjs.mxzg.processor.impl;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.processor.DataProcessor;
import com.ayjs.mxzg.processor.ProcessorType;

/**
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
public class ReserveSourceDataProcessor implements DataProcessor {

    @Override
    public ProcessorType getType() {
        return ProcessorType.RESERVE_SOURCE;
    }

    @Override
    public void beforeMerge(Class<? extends AbstractEntity> clz, String source) {
//        for (int serverId : Config.getInstance().getSource()) {
//            if (serverId != Config.getInstance().getTarget()) {
//                MergeRepository mergeRepository = MergeRepositoryManager.getInstance().get(serverId, source);
////                mergeRepository.truncateAll(clz);
//            }
//        }
    }

    @Override
    public void afterMerge(Class<? extends AbstractEntity> clz, String source) {

    }
}
