package com.ayjs.mxzg.gameserver.module.headPortrait.service;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.config.excel.cache.HeadUnlockSysCache;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.headPortrait.dao.RoleHeadPortraitDao;
import com.ayjs.mxzg.gameserver.module.headPortrait.domain.RoleHeadPortrait;
import com.ayjs.mxzg.gameserver.module.headPortrait.event.RolePortraitEvent;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.HeadPortraitGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.Set;

/**
 * 头像
 *
 * @author hyx
 */
@Service
public class RoleHeadPortraitService {

    @Autowired
    private RoleHeadPortraitDao roleHeadPortraitDao;
    @Autowired
    private HeadUnlockSysCache headUnlockSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private EventBus eventBus;

    /**
     * 查询玩家解锁头像
     *
     * @return
     */
    public RoleHeadPortrait select(long rid) {
        RoleHeadPortrait roleHeadPortrait = roleHeadPortraitDao.get(rid);
        if (roleHeadPortrait == null) {
            roleHeadPortrait = new RoleHeadPortrait();
            roleHeadPortrait.setRid(rid);
            roleHeadPortrait.getHeadIds().addAll(headUnlockSysCache.getUnlockHeadList());
            roleHeadPortraitDao.add(roleHeadPortrait);
        }
        return roleHeadPortrait;
    }

    /**
     * 更新解锁头像
     *
     * @param roleHeadPortrait
     */
    public void update(RoleHeadPortrait roleHeadPortrait) {
        roleHeadPortraitDao.update(roleHeadPortrait);
    }

    /**
     * 发送更换头像
     *
     * @param role
     */
    public void sendChangeHead(Role role, int headId) {
        HeadPortraitGMsg.GResChangeHeadPortrait.Builder builder = HeadPortraitGMsg.GResChangeHeadPortrait.newBuilder();

        role.setHeadId(headId);
        roleService.updateRole(role);

        builder.setIdx(headId);
        contextManager.write(role.getId(), CmdCode._34002, builder.build());

        eventBus.post(RolePortraitEvent.of(role.getId(), headId));
    }
}
