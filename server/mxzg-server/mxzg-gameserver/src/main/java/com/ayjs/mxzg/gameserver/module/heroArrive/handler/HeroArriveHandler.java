package com.ayjs.mxzg.gameserver.module.heroArrive.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.heroArrive.service.HeroArriveService;
import com.ayjs.mxzg.protocol.HeroArriveGMsg.GReqHeroArriveReward;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @description:
 * @author: CWJ
 * @date: 2019/10/13 22:26
 */
@Component
public class HeroArriveHandler extends ProtocolHandler {

    @Autowired
    HeroArriveService heroArriveService;

    /**
     * 英雄降临
     *
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._23001)
    public void rewardHeroArrive(PlayerContext playerContext, GReqHeroArriveReward req) {
        heroArriveService.rewardHeroArrive(playerContext.getId(), req.getIdx());
    }
}
