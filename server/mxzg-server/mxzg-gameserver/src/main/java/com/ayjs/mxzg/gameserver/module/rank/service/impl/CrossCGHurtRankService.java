package com.ayjs.mxzg.gameserver.module.rank.service.impl;

import com.ayjs.mxzg.gameserver.module.crusadegroup.group.dao.CrusadeGroupDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroup;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractRankService;
import com.ayjs.mxzg.message.module.rank.ResCrossCGHurtRankMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossCruGroupHurt;
import com.ayjs.mxzg.protocol.CrusadeGroupRankGMsg;
import com.ayjs.rpc.annotation.RemoteMethod;
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
 * 讨伐团boss伤害 排行
 **/
@Slf4j
@Service
public class CrossCGHurtRankService extends AbstractRankService<CrusadeGroupRankGMsg.PSCrusadeGroupRankData> implements MessageHandler {
    private Map<Long, CrossCruGroupHurt> cgDataMap = null;

    @Autowired
    private CrusadeGroupDao crusadeGroupDao;

    @Override
    public RankType getRankType() {
        return RankType.CRUGROUP_HURT;
    }

    @Override
    protected List<Rank> startLoadRank() {
//        messageDispatcher.dispatch();
//        if (!hadReq) {
//            messageDispatcher.dispatch(ReqCrossRankGetMessage.createOf(getRankType().getType(), serverConfig.getServerId()));
//            hadReq = true;
//        }
        List<Rank> list = new ArrayList<>();
        if (cgDataMap != null) {
            ImmutableList.copyOf(cgDataMap.values()).forEach(crossCruGroupHurt -> {
                Rank rank = new Rank();
                rank.setRankId(crossCruGroupHurt.getRankId());
                rank.setRankTime(crossCruGroupHurt.getRankTime());
                rank.setRankValue(crossCruGroupHurt.getBossHurt());
                list.add(rank);
            });
        }
        return list;
    }

    @RemoteMethod
    public void replaceRank(ResCrossCGHurtRankMessage message) {
        try {
            List<CrossCruGroupHurt> ranks = message.getRanks() == null ? new ArrayList<>() : message.getRanks();
            log.debug("跨服讨伐团boss伤害榜 数据量:{}", ranks.size());
            cgDataMap = ranks.stream().collect(Collectors.toMap(CrossCruGroupHurt::getRankId, Function.identity()));
            start();
        } catch (Exception e) {
            log.error("重载排行榜异常", e);
        }

    }

    @Override
    public CrusadeGroupRankGMsg.PSCrusadeGroupRankData builder(Rank rank) {
        CrossCruGroupHurt crossCruGroupHurt = cgDataMap.get(rank.getRankId());
        CrusadeGroupRankGMsg.PSCrusadeGroupRankData.Builder builder = CrusadeGroupRankGMsg.PSCrusadeGroupRankData.newBuilder();
        builder.setCgId(crossCruGroupHurt.getRankId());
        builder.setCgName(crossCruGroupHurt.getGroupName());
        builder.setEmblem(crossCruGroupHurt.getEmblem());
        builder.setBossHurt(crossCruGroupHurt.getBossHurt());
        builder.setRank(topN.getRank(rank.getRankId()));
        return builder.build();
    }

    @Override
    public CrusadeGroupRankGMsg.PSCrusadeGroupRankData builderForNotRank(long rankId) {
        CrusadeGroupRankGMsg.PSCrusadeGroupRankData.Builder builder = CrusadeGroupRankGMsg.PSCrusadeGroupRankData.newBuilder();
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        builder.setCgId(crusadeGroup.getGroupId());
        builder.setCgName(crusadeGroup.getGroupName());
        builder.setEmblem(crusadeGroup.getEmblem());
        builder.setBossHurt(0);
        builder.setRank(-1);
        return builder.build();
    }
}
