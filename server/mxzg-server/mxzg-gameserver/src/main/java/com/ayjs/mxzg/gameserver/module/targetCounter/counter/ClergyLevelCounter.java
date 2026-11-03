package com.ayjs.mxzg.gameserver.module.targetCounter.counter;

import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 神职等级
 *
 * @author hyx
 */
@Controller
public class ClergyLevelCounter implements Counter {

    @Autowired
    private RoleService roleService;

    @Override
    public TargetType thisType() {
        return TargetType.CLERGY_LEVEL;
    }

    @Override
    public int count(long rid, TargetStruct targetStruct) {
        return roleService.getOrThrow(rid).getClergyLevel();
    }

    @Override
    public long taskCount(long rid, TargetStruct targetStruct) {
        return count(rid, targetStruct);
    }

}
