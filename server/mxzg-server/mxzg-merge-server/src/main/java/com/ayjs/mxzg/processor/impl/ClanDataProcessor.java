package com.ayjs.mxzg.processor.impl;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.config.Config;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.processor.DataProcessor;
import com.ayjs.mxzg.processor.ProcessorType;
import com.ayjs.mxzg.repository.manager.MergeRepositoryManager;
import com.ayjs.mxzg.repository.persister.MergeRepository;
import com.google.common.collect.Maps;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @Author: CWJ
 * @Date: 2020/8/20
 **/
public class ClanDataProcessor implements DataProcessor {

    @Override
    public ProcessorType getType() {
        return ProcessorType.CLAN;
    }

    @Override
    public void beforeMerge(Class<? extends AbstractEntity> clz, String source) {
    }

    private void resetName(Clan clan) {
        clan.setClanName("s" + clan.getServerId() + clan.getClanName());
    }

    @Override
    public void afterMerge(Class<? extends AbstractEntity> clz, String source) {
        Map<String, List<Clan>> map = Maps.newHashMap();
        MergeRepository mergeRepository = MergeRepositoryManager.getInstance().get(Config.getInstance().getTarget(), source);
        List<Clan> roles = mergeRepository.listAll(Clan.class);
        roles.forEach(clan -> map.computeIfAbsent(clan.getClanName(), key -> new ArrayList<>()).add(clan));
        List<Clan> update = new ArrayList<>();
        map.values().forEach(clanList -> {
            if (clanList.size() > 1) {
                clanList.forEach(this::resetName);
                update.addAll(clanList);
            }
        });
        mergeRepository.update(update);
    }

}
