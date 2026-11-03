package com.ayjs.mxzg.gameserver.module.rank.service.impl;

import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractPlayerRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.remote.cross.event.CrossConnectedEvent;
import com.ayjs.mxzg.message.module.rank.ReqCrossRankGetMessage;
import com.ayjs.mxzg.message.module.rank.ResCrossFightingRankMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossClanRank;
import com.ayjs.mxzg.message.module.rank.dto.CrossFightingRank;
import com.ayjs.mxzg.protocol.PvpGMsg;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2019/12/18
 **/
@Service
@Slf4j
public class CrossFightingRankService extends AbstractPlayerRankService implements MessageHandler {

    private Map<Long, CrossFightingRank> crossMapData = null;

    @Override
    public RankType getRankType() {
        return RankType.CROSS_FIGHTING;
    }

    //请求跨服数据
    @Override
    protected List<Rank> startLoadRank() {
//        if (!hadReq) {
//            messageDispatcher.dispatch(ReqCrossRankGetMessage.createOf(getRankType().getType(), serverConfig.getServerId()));
//            hadReq = true;
//        }
        List<Rank> list = new ArrayList<>();
        if (crossMapData != null) {
            ImmutableList.copyOf(crossMapData.values()).forEach(crossFightingRank -> {
                Rank rank = new Rank();
                rank.setRankId(crossFightingRank.getRankId());
                rank.setRankTime(crossFightingRank.getRankTime());
                rank.setRankValue(crossFightingRank.getScore());
                list.add(rank);
            });
        }
        return list;
    }

    @RemoteMethod
    public void replaceRank(ResCrossFightingRankMessage message) {
        try {
            List<CrossFightingRank> ranks = message.getRanks() == null ? new ArrayList<>() : message.getRanks();
            log.debug("跨服战力排行榜数据量:{}", ranks.size());
            crossMapData = ranks.stream().collect(Collectors.toMap(CrossFightingRank::getRankId, Function.identity()));
            start();
        } catch (Exception e) {
            log.error("重载排行榜异常", e);
        }
    }

    @Override
    public PvpGMsg.PSRankPlayerData builder(Rank rank) {
        PvpGMsg.PSRankPlayerData.Builder builder = PvpGMsg.PSRankPlayerData.newBuilder();
        CrossFightingRank crossFightingRank = crossMapData.get(rank.getRankId());
        builder.setLevel(crossFightingRank.getLevel());
        builder.setName(crossFightingRank.getRoleName());
        builder.setPlayerId(rank.getRankId());
        builder.setRank(topN.getRank(rank.getRankId()));
        builder.setScore((int) rank.getRankValue());
        builder.setCombatNum((int) rank.getRankValue());
        builder.setHeadId(crossFightingRank.getHeadId());
        builder.setBorderId(crossFightingRank.getBorderId());
        builder.setServerId(crossFightingRank.getServerId());
        return builder.build();
    }


    @Override
    protected int getNotRankScore(Role role) {
        return role.getMaxFighting();
    }

}
