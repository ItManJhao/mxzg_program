package com.ayjs.mxzg.processor.impl;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.config.Config;
import com.ayjs.mxzg.processor.DataProcessor;
import com.ayjs.mxzg.processor.ProcessorType;
import com.ayjs.mxzg.repository.manager.MergeRepositoryManager;
import com.ayjs.mxzg.repository.persister.MergeRepository;

/**
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
public class TruncateAllDataProcessor implements DataProcessor {

    @Override
    public ProcessorType getType() {
        return ProcessorType.TRUNCATE_ALL;
    }

    @Override
    public void beforeMerge(Class<? extends AbstractEntity> clz, String source) {
//        for (int serverId : Config.getInstance().getSource()) {
        MergeRepository mergeRepository = MergeRepositoryManager.getInstance().get(Config.getInstance().getTarget(), source);
        mergeRepository.truncateAll(clz);
//        }
    }

    @Override
    public void afterMerge(Class<? extends AbstractEntity> clz, String source) {

    }
}
