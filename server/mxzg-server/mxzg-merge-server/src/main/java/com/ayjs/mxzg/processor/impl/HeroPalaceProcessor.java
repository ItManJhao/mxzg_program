package com.ayjs.mxzg.processor.impl;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.config.Config;
import com.ayjs.mxzg.gameserver.module.heropalace.domain.HeroPalace;
import com.ayjs.mxzg.processor.DataProcessor;
import com.ayjs.mxzg.processor.ProcessorType;
import com.ayjs.mxzg.repository.manager.MergeRepositoryManager;
import com.ayjs.mxzg.repository.persister.MergeRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/11/10
 **/
public class HeroPalaceProcessor implements DataProcessor {
    @Override
    public ProcessorType getType() {
        return ProcessorType.HERO_PALACE;
    }

    @Override
    public void beforeMerge(Class<? extends AbstractEntity> clz, String source) {
        MergeRepository mergeRepository = MergeRepositoryManager.getInstance().get(Config.getInstance().getTarget(), source);
        Map<Integer, HeroPalace> heroPalaces = mergeRepository.listAll(HeroPalace.class).stream().collect(Collectors.toMap(HeroPalace::getType, Function.identity()));
        for (int serverId : Config.getInstance().getSource()) {
            if (serverId != Config.getInstance().getTarget()) {
                MergeRepository subMergeRepository = MergeRepositoryManager.getInstance().get(serverId, source);
                List<HeroPalace> entities = subMergeRepository.listAll(HeroPalace.class);
                entities.forEach(subHeroPalace -> {
                    HeroPalace heroPalace = heroPalaces.get(subHeroPalace.getType());
//                    if (heroPalace==null){
//                        addType.add(subHeroPalace.getType());
//                    }
                    heroPalace.getRankRid().addAll(subHeroPalace.getRankRid());
                });
//                subMergeRepository.truncateAll(HeroPalace.class);
            }
        }
        mergeRepository.update(new ArrayList<>(heroPalaces.values()));
    }

    @Override
    public void afterMerge(Class<? extends AbstractEntity> clz, String source) {

    }
}
