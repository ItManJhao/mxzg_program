package com.ayjs.mxzg.processor.impl;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.config.Config;
import com.ayjs.mxzg.gameserver.module.tower.domain.TowerRaidersLog;
import com.ayjs.mxzg.processor.ProcessorType;
import com.ayjs.mxzg.repository.manager.MergeRepositoryManager;
import com.ayjs.mxzg.repository.persister.MergeRepository;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
public class TowerLogDataProcessor extends ReserveSourceDataProcessor {

    @Override
    public ProcessorType getType() {
        return ProcessorType.TOWER_LOG;
    }

    @Override
    public void beforeMerge(Class<? extends AbstractEntity> clz, String source) {
        Map<Integer, List<TowerRaidersLog>> map = Maps.newHashMap();
        MergeRepository mergeRepository = MergeRepositoryManager.getInstance().get(Config.getInstance().getTarget(), source);
        for (int serverId : Config.getInstance().getSource()) {
            if (serverId != Config.getInstance().getTarget()) {
                MergeRepository sourceRepository = MergeRepositoryManager.getInstance().get(serverId, source);
                Map<Integer, TowerRaidersLog> sourceLog = sourceRepository.listAll(TowerRaidersLog.class).stream().
                        collect(Collectors.toMap(TowerRaidersLog::getStage, Function.identity()));
                sourceLog.forEach((stage, log) -> map.computeIfAbsent(stage, key -> new ArrayList<>()).add(log));
            }
        }

        List<TowerRaidersLog> targetLogs = mergeRepository.listAll(TowerRaidersLog.class);
        List<TowerRaidersLog> addTargetLogs = Lists.newArrayList();
        map.forEach((stage, logs) -> {
            TowerRaidersLog towerRaidersLog = targetLogs.stream().filter(targetLog -> targetLog.getStage() == stage).findFirst().orElse(null);
            if (Objects.isNull(towerRaidersLog)) {
                towerRaidersLog = logs.get(0);
                for (int i = 1; i < logs.size(); i++) {
                    change(logs.get(i), towerRaidersLog);
                }
                addTargetLogs.add(towerRaidersLog);
            } else {
                for (int i = 0; i < logs.size(); i++) {
                    change(logs.get(i), towerRaidersLog);
                }
            }
        });

        mergeRepository.update(targetLogs);
        mergeRepository.add(addTargetLogs);


        super.beforeMerge(clz, source);
    }

    private void change(TowerRaidersLog source, TowerRaidersLog target) {
        if (target.fastestIsEmpty() || source.getFastest().getDuration() < target.getFastest().getDuration()) {
            target.setFastest(source.getFastest());
        }

        if (target.lowestIsEmpty() || source.getLowest().getAbility() < target.getLowest().getAbility()) {
            target.setLowest(source.getLowest());
        }
    }

    @Override
    public void afterMerge(Class<? extends AbstractEntity> clz, String source) {

    }

}
