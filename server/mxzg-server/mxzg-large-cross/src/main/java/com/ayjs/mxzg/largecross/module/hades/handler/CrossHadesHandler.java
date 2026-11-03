package com.ayjs.mxzg.largecross.module.hades.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.largecross.module.hades.domain.CrossHades;
import com.ayjs.mxzg.largecross.module.hades.event.HadesChallengeEvent;
import com.ayjs.mxzg.largecross.module.hades.service.CrossHadesService;
import com.ayjs.mxzg.largecross.module.rank.service.ICrossRankService;
import com.ayjs.mxzg.largecross.module.rank.service.RankHelper;
import com.ayjs.mxzg.message.module.hades.message.HadesChallengeReqMessage;
import com.ayjs.mxzg.message.module.hades.message.HadesRankReqMessage;
import com.ayjs.mxzg.message.module.role.dao.CrossRoleRedisDao;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.protocol.HadesGMsg;
import com.ayjs.rpc.annotation.Remote;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @Author: CWJ
 * @Date: 2021/1/5
 **/
@Remote
@Slf4j
public class CrossHadesHandler implements MessageHandler {
    @Autowired
    private CrossHadesService crossHadesService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private RankHelper rankHelper;
    @Autowired
    private CrossRoleRedisDao crossRoleRedisDao;

    @RemoteMethod
    public void challenge(HadesChallengeReqMessage message, Connection connection) {
        CrossRole crossRole = crossRoleRedisDao.get(message.getRid());
        if (crossRole == null) {
            log.error("玩家[{}]不存在", message.getRid());
            return;
        }
        CrossHades crossHades = crossHadesService.get(message.getRid());
        crossHades.updateFloor(message.getType(), message.getFloor());
        crossHades.setFighting(message.getFighting());
        crossHadesService.update(crossHades);
        eventBus.post(HadesChallengeEvent.of(message.getRid(), message.getType()));
        //推送到游戏服
        ICrossRankService service = rankHelper.getService(crossHadesService.hadesType2RankType(HadesGMsg.HadesType.valueOf(message.getType())));
        service.pullToGame(crossRole.getServerId(), connection);
    }

    @RemoteMethod
    public void getRank(HadesRankReqMessage message, Connection connection) {
        //推送到游戏服
        ICrossRankService service = rankHelper.getService(crossHadesService.hadesType2RankType(HadesGMsg.HadesType.valueOf(message.getHadesType())));
        service.pullToGame(message.getServerId(), connection);
    }
}
