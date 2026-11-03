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
import com.ayjs.mxzg.cross.module.crusadegroup.group.event.BossHurtChangeEvent;
import com.ayjs.mxzg.cross.module.crusadegroup.group.event.ShenBinItemChangeEvent;
import com.ayjs.mxzg.cross.module.rank.service.AbstractCrossRankService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.ResCrossCGHurtRankMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossCruGroupHurt;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;

/**
 * 讨伐团boss伤害 排行
 **/
@Observer
@Service
@Slf4j
public class CrossCruGroupHurtService extends AbstractCrossRankService<CrossCruGroupHurt> {
    private static final int serverId_ = 0;//全服排行，serverId统一

    @Autowired
    private CrossCrusadeGroupDao crossCrusadeGroupDao;

    @Autowired
    private CrossServerGroupDao crossServerGroupDao;

    @Override
    public CrossRankType getRankType() {
        return CrossRankType.CRUGROUP_HURT;
    }

    @Override
    protected Map<Integer, List<RankData>> startLoadRank() {
        Map<Integer, List<RankData>> map = new HashMap<>();
        List<CrossCrusadeGroup> list = crossCrusadeGroupDao.listAll();//拿到所有讨伐团
        for (CrossCrusadeGroup cruGroup : list) {
            List<RankData> crossRanks = map.computeIfAbsent(serverId_, key -> new ArrayList<>());
            RankData crossRank = new RankData();
            crossRank.setRankId(cruGroup.getId());
            crossRank.setRankTime(cruGroup.getBossHurtUpdateTime());
            crossRank.setRankValue(cruGroup.getBossHurtAll());
            crossRanks.add(crossRank);
        }
        return map;
    }

    @Override
    public List<CrossCruGroupHurt> getAll(int serverGroup) {
        TopN<Long, RankData> topN = groupTopN.get(serverId_);
        if (topN == null) {
            return new ArrayList<>();
        }
        List<RankData> top = topN.top(getRankType().getRankCount());
        List<CrossCruGroupHurt> crossCruGroupHurts = new ArrayList<>();
        top.forEach(crossRank -> {
            CrossCrusadeGroup crossCrusadeGroup = crossCrusadeGroupDao.get(crossRank.getRankId());
            CrossCruGroupHurt crossCruGroupHurt = new CrossCruGroupHurt();
            crossCruGroupHurt.setRankId(crossRank.getRankId());
            crossCruGroupHurt.setRank(topN.getRank(crossRank.getRankId()));
            crossCruGroupHurt.setEmblem(crossCrusadeGroup.getEmblem());
            crossCruGroupHurt.setGroupName(crossCrusadeGroup.getGroupName());
            crossCruGroupHurt.setBossHurt(crossRank.getRankValue());
            crossCruGroupHurt.setRankTime(crossRank.getRankTime());
            crossCruGroupHurts.add(crossCruGroupHurt);
        });
        return crossCruGroupHurts;
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(BossHurtChangeEvent event) {
        RankData rank = new RankData();
        rank.setRankValue(event.getNowHurt());
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
            List<CrossCruGroupHurt> ranks = getAll(serverId_);
            set.forEach(groupId -> {
                messageHelper.pushToGroupMessage(groupId, ResCrossCGHurtRankMessage.createOf(ranks));
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
        List<CrossCruGroupHurt> ranks = getAll(groupId);
        connection.send(ResCrossCGHurtRankMessage.createOf(ranks));
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
