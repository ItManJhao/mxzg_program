package com.ayjs.mxzg.processor.impl;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.config.Config;
import com.ayjs.mxzg.processor.DataProcessor;
import com.ayjs.mxzg.processor.ProcessorType;
import com.ayjs.mxzg.repository.manager.MergeRepositoryManager;
import com.ayjs.mxzg.repository.persister.MergeRepository;

import java.util.Arrays;

/**
 * @Author: CWJ
 * @Date: 2020/8/29
 **/
public class RemoveZeroDataProcessor implements DataProcessor {

    @Override
    public ProcessorType getType() {
        return ProcessorType.REMOVE_ZERO;
    }

    @Override
    public void beforeMerge(Class<? extends AbstractEntity> clz, String source) {
        for (int serverId : Config.getInstance().getSource()) {
            MergeRepository mergeRepository = MergeRepositoryManager.getInstance().get(serverId, source);
            AbstractEntity entity = mergeRepository.get(0l, clz);
            if (entity != null) {
                mergeRepository.remove(Arrays.asList(entity));
            }
        }
    }

    @Override
    public void afterMerge(Class<? extends AbstractEntity> clz, String source) {

    }
}
