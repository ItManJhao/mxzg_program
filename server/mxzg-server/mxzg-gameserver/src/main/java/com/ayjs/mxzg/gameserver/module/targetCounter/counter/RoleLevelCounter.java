package com.ayjs.mxzg.gameserver.module.targetCounter.counter;

import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @Author: CWJ
 * @Date: 2019/10/28
 **/
@Controller
public class RoleLevelCounter implements Counter {

    @Autowired
    private RoleService roleService;

    @Override
    public TargetType thisType() {
        return TargetType.ADVENTURE_LEVEL;
    }

    @Override
    public int count(long rid, TargetStruct targetStruct) {
        return roleService.getOrThrow(rid).getLevel();
    }

    @Override
    public long taskCount(long rid, TargetStruct targetStruct) {
        return count(rid, targetStruct);
    }
}
