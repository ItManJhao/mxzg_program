package com.ayjs.mxzg.gameserver.module.clergy.handle;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.ClergyPrivilegeSysCache;
import com.ayjs.mxzg.config.excel.entity.CClergyPrivilege;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.clergy.event.ClergyLevelEvent;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.ClergyGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 神职特权
 *
 * @author hyx
 */
@Controller
public class ClergyHandle extends ProtocolHandler {

    @Autowired
    private ClergyPrivilegeSysCache clergyPrivilegeSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EventBus eventBus;

    @CMD(id = CmdCode._46001)
    public void unlockClergyLevel(PlayerContext playerContext, ClergyGMsg.GReqUnlockClergyLevel msg) {

        Role role = roleService.getOrThrow(playerContext.getId());
        Asserts.isTrue(role.getClergyLevel() < msg.getClergyLevel(), ErrorCode.CLERGY_LEVEL_UNLOCK.getValue(),
                () -> String.format("当前神职已解锁ClergyLevel:%s", msg.getClergyLevel()));

        CClergyPrivilege cClergyPrivilege = clergyPrivilegeSysCache.getOrThrow(msg.getClergyLevel());
        Asserts.isTrue(cClergyPrivilege.getUnlock_need_exp() <= role.getClergyExp(),
                ErrorCode.CLERGY_EXP_COUNT_LOW.getValue(),
                () -> String.format("神职经验值不够升级所需need:%s target:%s", role.getClergyExp(), cClergyPrivilege.getUnlock_need_exp()));

        role.setClergyLevel(msg.getClergyLevel());
        roleService.updateRole(role);

        thingService.add(playerContext.getId(), cClergyPrivilege.getReward(), GameEvent.CLERGY_UP_LEVEL_REWARD);

        ClergyGMsg.GResUnlockClergyLevel.Builder builder = ClergyGMsg.GResUnlockClergyLevel.newBuilder();
        builder.setClergyLevel(role.getClergyLevel());
        playerContext.write(CmdCode._46001, builder.build());

        eventBus.post(ClergyLevelEvent.of(playerContext.getId(), role.getClergyLevel()));
    }


}
