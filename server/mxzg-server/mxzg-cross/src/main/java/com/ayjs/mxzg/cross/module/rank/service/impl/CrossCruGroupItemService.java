package com.ayjs.mxzg.cross.module.rank.service.impl;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.cross.module.crossservice.dao.CrossServerGroupDao;
import com.ayjs.mxzg.cross.module.crossservice.domain.CrossServerGroup;
import com.ayjs.mxzg.cross.module.crossservice.event.CrossRegroupEvent;
import com.ayjs.mxzg.cross.module.crusadegroup.group.dao.CrossCrusadeGroupDao;
import com.ayjs.mxzg.cross.module.crusadegroup.group.domain.CrossCrusadeGroup;
import com.ayjs.mxzg.cross.module.crusadegroup.group.event.ShenBinItemChangeEvent;
import com.ayjs.mxzg.cross.module.crusadegroup.group.event.ShenBinItemPChangeEvent;
import com.ayjs.mxzg.cross.module.rank.service.AbstractCrossRankService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.ResCrossCGItemRankMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossCruGroupItem;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * 讨伐团神兵精华 排行
 **/
@Observer
@Service
@Slf4j
public class CrossCruGroupItemService extends AbstractCrossRankService<CrossCruGroupItem> {

    private static final int serverId_ = 0;//全服排行，serverId统一

    @Autowired
    private CrossCrusadeGroupDao crossCrusadeGroupDao;

    @Autowired
    private CrossServerGroupDao crossServerGroupDao;

    @Override
    public CrossRankType getRankType() {
        return CrossRankType.CRUGROUP_ITEM;
    }

    @Override
    protected Map<Integer, List<RankData>> startLoadRank() {
        Map<Integer, List<RankData>> map = new HashMap<>();
        List<CrossCrusadeGroup> list = crossCrusadeGroupDao.listAll();//拿到所有讨伐团
        for (CrossCrusadeGroup cruGroup : list) {
            List<RankData> crossRanks = map.computeIfAbsent(serverId_, key -> new ArrayList<>());
            RankData crossRank = new RankData();
            crossRank.setRankId(cruGroup.getId());
            crossRank.setRankTime(cruGroup.getShenBinUpdateTime());
            crossRank.setRankValue(cruGroup.getShenBinAll());
            crossRanks.add(crossRank);
        }
        return map;
    }

    @Override
    public List<CrossCruGroupItem> getAll(int serverGroup) {
        TopN<Long, RankData> topN = groupTopN.get(serverId_);
        if (topN == null) {
            return new ArrayList<>();
        }
        List<RankData> top = topN.top(getRankType().getRankCount());
        List<CrossCruGroupItem> crossCruGroupItems = new ArrayList<>();
        top.forEach(crossRank -> {
            CrossCrusadeGroup crossCrusadeGroup = crossCrusadeGroupDao.get(crossRank.getRankId());
            CrossCruGroupItem crossCruGroupItem = new CrossCruGroupItem();
            crossCruGroupItem.setRankId(crossRank.getRankId());
            crossCruGroupItem.setRank(topN.getRank(crossRank.getRankId()));
            crossCruGroupItem.setEmblem(crossCrusadeGroup.getEmblem());
            crossCruGroupItem.setGroupName(crossCrusadeGroup.getGroupName());
            crossCruGroupItem.setShenBinJh(crossRank.getRankValue());
            crossCruGroupItem.setRankTime(crossRank.getRankTime());
            crossCruGroupItems.add(crossCruGroupItem);
        });
        return crossCruGroupItems;
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ShenBinItemChangeEvent event) {
        RankData rank = new RankData();
        rank.setRankValue(event.getNowNum());
        rank.setRankId(event.getCgId());
        rank.setRankTime(TimeDateUtil.getCurrentTimeInt());
        addRank(rank, serverId_);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CrossRegroupEvent event) {
        resetRankList();
    }

    @Override
    public void pullToAllGame() {
        if (resetIng)
            return;
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        Set<Integer> set = new HashSet<>(crossServerGroup.getGroups().keySet());
        if (topHadChange.getOrDefault(serverId_, true)) {
            topHadChange.put(serverId_, false);
            List<CrossCruGroupItem> ranks = getAll(serverId_);
            set.forEach(groupId -> {
                messageHelper.pushToGroupMessage(groupId, ResCrossCGItemRankMessage.createOf(ranks));
            });
        }
    }

    @Override
    public void pullToGame(int serverId, Connection connection) {
        if (resetIng)
            return;
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        CrossGroup group = crossServerGroup.getGroupByServerId(serverId);
        if (group == null) {
            return;
        }
        int groupId = group.getGroupId();
        List<CrossCruGroupItem> ranks = getAll(groupId);
        connection.send(ResCrossCGItemRankMessage.createOf(ranks));
    }

    /**
     * 重写该方法，主要是区分当前排行为全服务排行
     *
     * @param serverId
     * @return
     */
    @Override
    public TopN<Long, RankData> getTopNByServerId(int serverId) {
        TopN<Long, RankData> topN = groupTopN.get(serverId_);
        if (topN == null) {
            return null;
        }
        return topN;
    }

}
