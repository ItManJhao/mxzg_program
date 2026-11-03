package com.ayjs.mxzg.gameserver.module.targetCounter.counter;

import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @Author: CWJ
 * @Date: 2019/11/15
 **/
@Service
public class RoleMaxFightCounter implements Counter {
    @Autowired
    private RoleService roleService;

    @Override
    public TargetType thisType() {
        return TargetType.ROLE_MAX_FIGHTING;
    }

    @Override
    public int count(long rid, TargetStruct targetStruct) {
        return roleService.getOrThrow(rid).getMaxFighting();
    }

    @Override
    public long taskCount(long rid, TargetStruct targetStruct) {
        return count(rid, targetStruct);
    }
}
