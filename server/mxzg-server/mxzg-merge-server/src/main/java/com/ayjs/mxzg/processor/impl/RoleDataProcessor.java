package com.ayjs.mxzg.processor.impl;

import com.ayjs.mxzg.common.persistence.AbstractEntity;
import com.ayjs.mxzg.config.Config;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
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
public class RoleDataProcessor implements DataProcessor {

    @Override
    public ProcessorType getType() {
        return ProcessorType.ROLE;
    }

    @Override
    public void beforeMerge(Class<? extends AbstractEntity> clz, String source) {
    }

    private void resetName(Role role) {
        role.setNick("s" + role.getServerId() + role.getNick());
    }

    @Override
    public void afterMerge(Class<? extends AbstractEntity> clz, String source) {
        Map<String, List<Role>> map = Maps.newHashMap();
        MergeRepository mergeRepository = MergeRepositoryManager.getInstance().get(Config.getInstance().getTarget(), source);
        List<Role> roles = mergeRepository.listAll(Role.class);
        roles.forEach(role -> map.computeIfAbsent(role.getNick(), key -> new ArrayList<>()).add(role));
        List<Role> update = new ArrayList<>();
        map.values().forEach(roleTemp -> {
            if (roleTemp.size() > 1) {
                roleTemp.forEach(this::resetName);
                update.addAll(roleTemp);
            }
        });
        mergeRepository.update(update);
    }


}
