package com.ayjs.mxzg.processor.impl;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.config.Config;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import com.ayjs.mxzg.processor.DataProcessor;
import com.ayjs.mxzg.processor.ProcessorType;
import com.ayjs.mxzg.repository.manager.MergeRepositoryManager;
import com.ayjs.mxzg.repository.persister.MergeRepository;

import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
public class SpaceTimeInfoProcessor implements DataProcessor {

    @Override
    public ProcessorType getType() {
        return ProcessorType.SPACE_TIME_INFO;
    }

    @Override
    public void beforeMerge(Class<? extends AbstractEntity> clz, String source) {
        for (int serverId : Config.getInstance().getSource()) {
            MergeRepository mergeRepository = MergeRepositoryManager.getInstance().get(serverId, source);
            List<SpaceTimeInfo> all = mergeRepository.listAll(SpaceTimeInfo.class);
            all = all.stream().filter(spaceTimeInfo -> spaceTimeInfo.getRid() < 1000).collect(Collectors.toList());
            if (all != null || all.size() > 0) {
                mergeRepository.remove(all);
            }
        }
    }

    @Override
    public void afterMerge(Class<? extends AbstractEntity> clz, String source) {

    }

}
