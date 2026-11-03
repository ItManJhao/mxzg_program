package com.ayjs.mxzg.gameserver.module.skinshop.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.skinshop.service.SkinShopService;
import com.ayjs.mxzg.protocol.HeroSkinGMsg.GReqHeroSkinList;
import com.ayjs.mxzg.protocol.HeroSkinGMsg.GResHeroSkinList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;

/**
 * @author Rondo
 * 2021-06-11 15:35:47
 */
@Controller
public class SkinShopHandler extends ProtocolHandler {

    @Autowired
    private SkinShopService skinShopService;

    @CMD(id = CmdCode._76397)
    public void reqSkinSHopList(PlayerContext playerContext, GReqHeroSkinList req){
        long rid = playerContext.getId();
        List<Integer> list = skinShopService.getFashionByRid(rid);
        GResHeroSkinList.Builder proto = GResHeroSkinList.newBuilder();
        proto.addAllSkins(list);
        playerContext.write(CmdCode._76397, proto.build());
    }
}
