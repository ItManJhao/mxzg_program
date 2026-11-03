package com.ayjs.mxzg.gameserver.module.hades.handler;

import com.ayjs.mxzg.gameserver.module.hades.service.AbstractHadesRankService;
import com.ayjs.mxzg.gameserver.module.hades.service.HadesService;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.service.RankServiceProxy;
import com.ayjs.mxzg.message.module.hades.message.HadesUpdateRankMessage;
import com.ayjs.mxzg.protocol.HadesGMsg;
import com.ayjs.rpc.annotation.Remote;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * @Author: CWJ
 * @Date: 2021/1/13
 **/
@Remote
@Component
public class HadesCrossMessageHandler implements MessageHandler {

    @Autowired
    private RankServiceProxy rankServiceProxy;
    @Autowired
    private HadesService hadesService;

    @RemoteMethod
    public void updateRank(HadesUpdateRankMessage message) {
        RankType rankType = hadesService.hadesType2RankType(HadesGMsg.HadesType.valueOf(message.getHadesType()));
        AbstractHadesRankService rankService = (AbstractHadesRankService) rankServiceProxy.getRankService(rankType);
        rankService.replaceRank(message);
    }

}
