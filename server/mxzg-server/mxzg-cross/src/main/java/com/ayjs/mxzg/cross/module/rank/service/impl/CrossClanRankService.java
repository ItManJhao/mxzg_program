package com.ayjs.mxzg.cross.module.rank.service.impl;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.cross.module.clan.dao.CrossClanDao;
import com.ayjs.mxzg.cross.module.clan.domain.CrossClan;
import com.ayjs.mxzg.cross.module.clan.event.ClanFightChangeEvent;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.dao.CrossServerGroupDao;
import com.ayjs.mxzg.cross.module.crossservice.domain.CrossServerGroup;
import com.ayjs.mxzg.cross.module.crossservice.event.CrossRegroupEvent;
import com.ayjs.mxzg.cross.module.rank.service.AbstractCrossRankService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.ResCrossClanRankMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossClanRank;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.rpc.server.Connection;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2019/12/19
 **/
@Observer
@Service
@Slf4j
public class CrossClanRankService extends AbstractCrossRankService<CrossClanRank> {

    @Autowired
    private CrossClanDao crossClanDao;
    @Autowired
    private CrossServerGroupDao crossServerGroupDao;
    @Autowired
    private CrossRoleService crossRoleService;

    @Override
    public CrossRankType getRankType() {
        return CrossRankType.CROSS_CLAN;
    }

    @Override
    protected Map<Integer, List<RankData>> startLoadRank() {
        Map<Integer, List<RankData>> map = new HashMap<>();
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        Map<Integer, List<CrossClan>> serverIds = crossClanDao.listAll().stream().collect(Collectors.groupingBy(CrossClan::getServerId));
        serverIds.forEach((serverId, list) -> {
            CrossGroup group = crossServerGroup.getGroupByServerId(serverId);
            if (group != null) {
                List<RankData> crossRanks = map.computeIfAbsent(group.getGroupId(), key -> new ArrayList<>());
                list.forEach(crossRole -> {
                    RankData crossRank = new RankData();
                    crossRank.setRankId(crossRole.getId());
                    crossRank.setRankTime(crossRole.getFightingUpdateTime());
                    crossRank.setRankValue(crossRole.getClanFighting());
                    crossRanks.add(crossRank);
                });
            }
        });
        return map;
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(ClanFightChangeEvent event) {
        RankData rank = new RankData();
        rank.setRankValue(event.getFight());
        rank.setRankId(event.getClanId());
        rank.setRankTime(TimeDateUtil.getCurrentTimeInt());

        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        CrossGroup group = crossServerGroup.getGroupByServerId(event.getServerId());
        if (group != null) {
            addRank(rank, group.getGroupId());
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CrossRegroupEvent event) {
        resetRankList();
    }

    @Override
    public List<CrossClanRank> getAll(int serverGroup) {
        TopN<Long, RankData> topN = groupTopN.get(serverGroup);
        if (topN == null) {
            return new ArrayList<>();
        }
        List<RankData> top = topN.top(getRankType().getRankCount());
        List<CrossClanRank> crossClanRanks = new ArrayList<>();
        top.forEach(crossRank -> {
            CrossClan clan = crossClanDao.get(crossRank.getRankId());
            CrossClanRank crossClanRank = new CrossClanRank();
            crossClanRank.setClanId(crossRank.getRankId());
            crossClanRank.setRank(topN.getRank(crossRank.getRankId()));
            crossClanRank.setClanId(clan.getId());
            crossClanRank.setClanLevel(clan.getClanLevel());
            crossClanRank.setClanName(clan.getClanName());
            crossClanRank.setClanPhoto(clan.getClanIcon());
            CrossRole role = crossRoleService.getNotThrow(clan.getClanHeadRid());
            if (Objects.nonNull(role)) {
                crossClanRank.setHeadName(role.getNick());
            } else {
                crossClanRank.setHeadName(clan.getClanHeadName());
            }
            crossClanRank.setServerId(clan.getServerId());
            crossClanRank.setScore(crossRank.getRankValue());
            crossClanRank.setRankTime(crossRank.getRankTime());
            crossClanRanks.add(crossClanRank);
        });
        return crossClanRanks;
    }

    @Override
    public void pullToAllGame() {
        if (resetIng)
            return;
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        Set<Integer> set = new HashSet<>(crossServerGroup.getGroups().keySet());
        set.forEach(groupId -> {
            if (topHadChange.getOrDefault(groupId, true)) {
                topHadChange.put(groupId, false);
                List<CrossClanRank> ranks = getAll(groupId);
                messageHelper.pushToGroupMessage(groupId, ResCrossClanRankMessage.createOf(ranks));
            }
        });
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
        List<CrossClanRank> ranks = getAll(groupId);
        connection.send(ResCrossClanRankMessage.createOf(ranks));
    }
}
