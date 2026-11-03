package com.ayjs.mxzg.gameserver.module.promotionNew.promotion098;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion098.service.Promotion098service;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.Promotion098GMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @author Rondo
 * 2021-07-05 14:12:38
 */
@Controller
public class Promotion098Handler extends ProtocolHandler {

    @Autowired
    private RoleService roleService;
    @Autowired
    private Promotion098service promotion098service;

    @CMD(id = CmdCode._76530)
    public void reqActiveJumpInfo(PlayerContext playerContext, Promotion098GMsg.GReqActiveJumpDataInfo req) {
        long rid = playerContext.getId();
        Role role = roleService.getOrThrow(rid);

        if (!promotion098service.isOpening()) {
            playerContext.write(CmdCode._76305, Promotion098GMsg.GResActiveJumpDataInfo.getDefaultInstance());
            return;
        }
        String place = role.getPlace();
        Promotion098GMsg.GResActiveJumpDataInfo.Builder proto = Promotion098GMsg.GResActiveJumpDataInfo.newBuilder();
        proto.addAllInfos(promotion098service.getPbDataByPlace(rid, place));
        playerContext.write(CmdCode._76530, proto.build());

    }
}
