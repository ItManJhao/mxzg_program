package com.ayjs.mxzg.cross.module.rank.service.impl;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.cross.module.crossrole.event.RoleFightChangeEvent;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.dao.CrossServerGroupDao;
import com.ayjs.mxzg.cross.module.crossservice.domain.CrossServerGroup;
import com.ayjs.mxzg.cross.module.crossservice.event.CrossRegroupEvent;
import com.ayjs.mxzg.cross.module.rank.service.AbstractCrossRankService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.ResCrossFightingRankMessage;
import com.ayjs.mxzg.message.module.rank.dto.CrossFightingRank;
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
public class CrossFightingRankService extends AbstractCrossRankService<CrossFightingRank> {

    @Autowired
    private CrossRoleService crossRoleService;
    @Autowired
    private CrossServerGroupDao crossServerGroupDao;

    @Override
    public CrossRankType getRankType() {
        return CrossRankType.CROSS_FIGHTING;
    }

    @Override
    protected Map<Integer, List<RankData>> startLoadRank() {

        Map<Integer, List<RankData>> map = new HashMap<>();
        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        Map<Integer, List<CrossRole>> serverIds = crossRoleService.getAllRoles().stream().collect(Collectors.groupingBy(CrossRole::getServerId));
        serverIds.forEach((serverId, list) -> {
            CrossGroup group = crossServerGroup.getGroupByServerId(serverId);
            if (group != null) {
                List<RankData> crossRanks = map.computeIfAbsent(group.getGroupId(), key -> new ArrayList<>());
                list.forEach(crossRole -> {
                    RankData crossRank = new RankData();
                    crossRank.setRankId(crossRole.getId());
                    crossRank.setRankTime(crossRole.getFightRankTime());
                    crossRank.setRankValue(crossRole.getFighting());
                    crossRanks.add(crossRank);
                });
            }
        });
        return map;

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(RoleFightChangeEvent event) {
        RankData rank = new RankData();
        rank.setRankValue(event.getNewFight());
        rank.setRankId(event.getRid());
        rank.setRankTime(TimeDateUtil.getCurrentTimeInt());

        CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        CrossGroup group = crossServerGroup.getGroupByServerId(event.getServerId());
        if (group != null) {
            addRank(rank, group.getGroupId());
        }
    }

    @Override
    public List<CrossFightingRank> getAll(int serverGroup) {
        TopN<Long, RankData> topN = groupTopN.get(serverGroup);
        if (topN == null) {
            return new ArrayList<>();
        }
        List<RankData> top = topN.top(getRankType().getRankCount());
        List<CrossFightingRank> crossClanRanks = new ArrayList<>();
        top.forEach(crossRank -> {
            CrossRole crossRole = crossRoleService.getNotThrow(crossRank.getRankId());
            if (Objects.nonNull(crossRole)) {
                CrossFightingRank crossFightingRank = new CrossFightingRank();
                crossFightingRank.setRankId(crossRank.getRankId());
                crossFightingRank.setRank(topN.getRank(crossRank.getRankId()));
                crossFightingRank.setLevel(crossRole.getLevel());
                crossFightingRank.setRoleName(crossRole.getNick());
                crossFightingRank.setBorderId(crossRole.getBorderId());
                crossFightingRank.setScore(crossRank.getRankValue());
                crossFightingRank.setServerId(crossRole.getServerId());
                crossFightingRank.setScore(crossRank.getRankValue());
                crossFightingRank.setRankTime(crossFightingRank.getRankTime());
                crossFightingRank.setHeadId(crossRole.getHeadId());
                crossClanRanks.add(crossFightingRank);
            }
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
                List<CrossFightingRank> ranks = getAll(groupId);
                log.info(String.format("推送跨服战力榜,数量{%s}到跨服组{%s}", ranks.size(), groupId));
                messageHelper.pushToGroupMessage(groupId, ResCrossFightingRankMessage.createOf(ranks));
            }
        });
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CrossRegroupEvent event) {
        resetRankList();
        pullToAllGame();
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
        List<CrossFightingRank> ranks = getAll(groupId);
        connection.send(ResCrossFightingRankMessage.createOf(ranks));
    }
}
