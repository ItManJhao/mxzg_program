package com.ayjs.mxzg.cross.module.rank.handle;

import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.clan.dao.CrossClanDao;
import com.ayjs.mxzg.cross.module.crossrole.dao.CrossRoleDao;
import com.ayjs.mxzg.cross.module.crossservice.dao.CrossServerGroupDao;
import com.ayjs.mxzg.cross.module.crossservice.domain.CrossServerGroup;
import com.ayjs.mxzg.cross.module.rank.service.ICrossRankService;
import com.ayjs.mxzg.cross.module.rank.service.RankHelper;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.ReqCrossRankGetMessage;
import com.ayjs.mxzg.message.module.rank.ReqCrossRankWorshipMessage;
import com.ayjs.mxzg.message.module.rank.ResCrossRankWorshipMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2019/12/19
 **/
@Component
@Slf4j
public class CrossRankHandler implements MessageHandler {

    @Autowired
    private CrossRoleDao crossRoleDao;
    @Autowired
    private CrossClanDao crossClanDao;
    @Autowired
    private RankHelper rankHelper;
    @Autowired
    private CrossServerGroupDao crossServerGroupDao;
    @Autowired
    private MessageHelper messageHelper;

    @RemoteMethod
    public void crossWorship(ReqCrossRankWorshipMessage message) {
        CrossRankType type = CrossRankType.typeOf(message.getType());
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        int groupId = crossServerGroup.getGroupByServerId(message.getServerId()).getGroupId();
        ICrossRankService rankService = rankHelper.getService(type);
        RankData rank = rankService.getRank(groupId, 1);
        if (Objects.isNull(rank)) {
            log.error("膜拜对象不存在");
            return;
        }
        CrossRole beWorship = crossRoleDao.get(rank.getRankId());
        CrossRole worship = crossRoleDao.get(message.getRid());
        if (Objects.isNull(beWorship) || Objects.isNull(worship)) {
            log.error("膜拜对象不存在");
            return;
        }
        ResCrossRankWorshipMessage res = ResCrossRankWorshipMessage.createOf(worship.getId(), worship.getServerId(),
                worship.getNick(), beWorship.getId(), beWorship.getServerId(), message.getType());
        messageHelper.pushToMessage(res);

    }

    @RemoteMethod
    public void reqRankList(ReqCrossRankGetMessage message, Connection connection) {
//        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
//        int groupId = crossServerGroup.getServerGroups().get(message.getServerId()).getGroupId();
        CrossRankType type = CrossRankType.typeOf(message.getType());
        ICrossRankService rankService = rankHelper.getService(type);
        if (rankService != null) {
            rankService.pullToGame(message.getServerId(), connection);
        }
    }
}
