package com.ayjs.mxzg.gameserver.module.rank.service.impl;

import com.ayjs.mxzg.gameserver.module.crusadegroup.group.dao.CrusadeGroupDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroup;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractRankService;
import com.ayjs.mxzg.message.module.rank.ResCrossCGItemRankMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossCruGroupItem;
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
 * 讨伐团神兵精华 排行
 **/
@Slf4j
@Service
public class CrossCGItemRankService extends AbstractRankService<CrusadeGroupRankGMsg.PSCrusadeGroupRankData> implements MessageHandler {

    private Map<Long, CrossCruGroupItem> cgDataMap = null;

    @Autowired
    private CrusadeGroupDao crusadeGroupDao;

    @Override
    public RankType getRankType() {
        return RankType.CRUGROUP_ITEM;
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
            ImmutableList.copyOf(cgDataMap.values()).forEach(crossCruGroupItem -> {
                Rank rank = new Rank();
                rank.setRankId(crossCruGroupItem.getRankId());
                rank.setRankTime(crossCruGroupItem.getRankTime());
                rank.setRankValue(crossCruGroupItem.getShenBinJh());
                list.add(rank);
            });
        }
        return list;
    }

    @RemoteMethod
    public void replaceRank(ResCrossCGItemRankMessage message) {
        try {
            List<CrossCruGroupItem> ranks = message.getRanks() == null ? new ArrayList<>() : message.getRanks();
            log.debug("跨服讨伐团神兵精华榜 数据量:{}", ranks.size());
            cgDataMap = ranks.stream().collect(Collectors.toMap(CrossCruGroupItem::getRankId, Function.identity()));
            start();
        } catch (Exception e) {
            log.error("重载排行榜异常", e);
        }

    }

    @Override
    public CrusadeGroupRankGMsg.PSCrusadeGroupRankData builder(Rank rank) {
        CrossCruGroupItem crossCruGroupItem = cgDataMap.get(rank.getRankId());
        CrusadeGroupRankGMsg.PSCrusadeGroupRankData.Builder builder = CrusadeGroupRankGMsg.PSCrusadeGroupRankData.newBuilder();
        builder.setCgId(crossCruGroupItem.getRankId());
        builder.setCgName(crossCruGroupItem.getGroupName());
        builder.setEmblem(crossCruGroupItem.getEmblem());
        builder.setShenBinJh(crossCruGroupItem.getShenBinJh());
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
        builder.setShenBinJh(0);
        builder.setRank(-1);
        return builder.build();
    }

}
