package com.ayjs.mxzg.gameserver.module.worldLevel.service;


import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;

@Service
public class WorldLevelService {

    @Autowired
    private RoleService roleService;
    @Autowired
    private SystemSysCache systemSysCache;
}
