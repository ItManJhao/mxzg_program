package com.ayjs.mxzg.gameserver.module.rank.service.impl;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractClanRankService;
import com.ayjs.mxzg.message.module.rank.ReqCrossRankGetMessage;
import com.ayjs.mxzg.message.module.rank.ResCrossClanRankMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossClanRank;
import com.ayjs.mxzg.protocol.PvpGMsg;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2019/10/16 公会战力排行榜
 **/
@Service
@Observer
@Slf4j
public class CrossClanRankService extends AbstractClanRankService implements MessageHandler {

    private Map<Long, CrossClanRank> crossMapData = null;

    @Override
    public RankType getRankType() {
        return RankType.CROSS_CLAN;
    }

    @Override
    protected long getNotRankScore(Clan clan, long fighting) {
        return fighting;
    }

    @Override
    protected List<Rank> startLoadRank() {
//        messageDispatcher.dispatch();
//        if (!hadReq) {
//            messageDispatcher.dispatch(ReqCrossRankGetMessage.createOf(getRankType().getType(), serverConfig.getServerId()));
//            hadReq = true;
//        }
        List<Rank> list = new ArrayList<>();
        if (crossMapData != null) {
            ImmutableList.copyOf(crossMapData.values()).forEach(crossClanRank -> {
                Rank rank = new Rank();
                rank.setRankId(crossClanRank.getClanId());
                rank.setRankTime(crossClanRank.getRankTime());
                rank.setRankValue(crossClanRank.getScore());
                list.add(rank);
            });
        }
        return list;
    }

    @RemoteMethod
    public void replaceRank(ResCrossClanRankMessage message) {
        try {

            List<CrossClanRank> ranks = message.getRanks() == null ? new ArrayList<>() : message.getRanks();
            log.debug("跨服公会排行榜数据量:{}", ranks.size());
            crossMapData = ranks.stream().collect(Collectors.toMap(CrossClanRank::getClanId, Function.identity()));
            start();
        } catch (Exception e) {
            log.error("重载排行榜异常", e);
        }

    }

    @Override
    public PvpGMsg.PSClanRankData builder(Rank rank) {
        CrossClanRank clan = crossMapData.get(rank.getRankId());

        PvpGMsg.PSClanRankData.Builder builder = PvpGMsg.PSClanRankData.newBuilder();
        builder.setRank(topN.getRank(rank.getRankId()));
        builder.setDamage(rank.getRankValue());

        builder.setClanId(clan.getClanId());
        builder.setClanLevel(clan.getClanLevel());
        builder.setClanName(clan.getClanName());
        builder.setClanPhoto(clan.getClanPhoto());
        builder.setHeadName(clan.getHeadName());
        builder.setServerId(clan.getServerId());
        builder.setScore(rank.getRankValue());
        return builder.build();
    }

}
