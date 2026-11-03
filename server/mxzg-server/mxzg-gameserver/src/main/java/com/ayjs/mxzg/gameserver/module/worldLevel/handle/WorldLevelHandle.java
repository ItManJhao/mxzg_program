package com.ayjs.mxzg.gameserver.module.worldLevel.handle;


import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.worldLevel.manager.WorldLevelManager;
import com.ayjs.mxzg.protocol.WorldLevelGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

@Controller
public class WorldLevelHandle extends ProtocolHandler {

    @Autowired
    private WorldLevelManager worldLevelService;

    @CMD(id = CmdCode._51001)
    public void getWorldLevel(PlayerContext playerContext, WorldLevelGMsg.GReqWorldLevel msg){
        WorldLevelGMsg.GResWorldLevel.Builder builder = WorldLevelGMsg.GResWorldLevel.newBuilder();

        builder.setLevel(worldLevelService.getWorldLevel());

        playerContext.write(CmdCode._51001,builder.build());
    }


}
