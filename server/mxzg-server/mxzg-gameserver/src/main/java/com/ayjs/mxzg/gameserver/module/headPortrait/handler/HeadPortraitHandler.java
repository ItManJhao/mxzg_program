package com.ayjs.mxzg.gameserver.module.headPortrait.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.headPortrait.domain.RoleHeadPortrait;
import com.ayjs.mxzg.gameserver.module.headPortrait.event.RolePortraitEvent;
import com.ayjs.mxzg.gameserver.module.headPortrait.service.RoleHeadPortraitService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.HeadPortraitGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

@Controller
public class HeadPortraitHandler extends ProtocolHandler {

    @Autowired
    private RoleHeadPortraitService roleHeadPortraitService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private EventBus eventBus;


    /**
     * 获取头像列表
     *
     * @param playerContext
     */
    @CMD(id = CmdCode._34001)
    public void getHeadPortraitList(PlayerContext playerContext, HeadPortraitGMsg.GReqHeadPortraitList msg) {
        HeadPortraitGMsg.GResHeadPortraitList.Builder builder = HeadPortraitGMsg.GResHeadPortraitList.newBuilder();
        RoleHeadPortrait roleHeadPortrait = roleHeadPortraitService.select(playerContext.getId());
        builder.addAllIdxList(roleHeadPortrait.getHeadIds());
        playerContext.write(CmdCode._34001, builder.build());
    }

    /**
     * 更换头像
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._34002)
    public void changeHeadPortrait(PlayerContext playerContext, HeadPortraitGMsg.GReqChangeHeadPortrait msg) {

        RoleHeadPortrait roleHeadPortrait = roleHeadPortraitService.select(playerContext.getId());

        Asserts.isTrue(roleHeadPortrait.getHeadIds().contains(msg.getIdx()), ErrorCode.Head_Portrait_NOT_UNLOCK.getValue(), "当前角色头像未解锁：" + msg.getIdx());

        Role role = roleService.getOrThrow(playerContext.getId());
        roleHeadPortraitService.sendChangeHead(role, msg.getIdx());
    }
}
