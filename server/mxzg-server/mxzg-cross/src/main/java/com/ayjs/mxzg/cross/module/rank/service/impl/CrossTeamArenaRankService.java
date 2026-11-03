package com.ayjs.mxzg.cross.module.rank.service.impl;


import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.domain.CrossServerGroup;
import com.ayjs.mxzg.cross.module.crossservice.event.CrossRegroupEvent;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.cross.module.rank.event.TeamArenaRankPullToServerEvent;
import com.ayjs.mxzg.cross.module.rank.service.AbstractCrossRankService;
import com.ayjs.mxzg.cross.module.teamArena.domain.CrossArenaTeam;
import com.ayjs.mxzg.cross.module.teamArena.event.TeamArenaScoreChangeEvent;
import com.ayjs.mxzg.cross.module.teamArena.service.CrossTeamArenaService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.message.module.teamArena.domain.ArenaTeamData;
import com.ayjs.mxzg.message.module.teamArena.domain.ArenaTeamMember;
import com.ayjs.mxzg.message.module.teamArena.domain.RoleSimpleMessage;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaRankData;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaChangeStateReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaGetDataResMessage;
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
 * @Date: 2020/4/11
 **/
@Service
@Slf4j
@Observer
public class CrossTeamArenaRankService extends AbstractCrossRankService<TeamArenaRankData> {

    @Autowired
    private CrossTeamArenaService crossTeamArenaService;
    @Autowired
    private CrossServerGroupService serverGroupService;
    @Autowired
    private CrossRoleService crossRoleService;
    @Autowired
    private EventBus eventBus;


    @Override
    public CrossRankType getRankType() {
        return CrossRankType.CROSS_TEAM_ARENA;
    }

    @Override
    protected Map<Integer, List<RankData>> startLoadRank() {
        Map<Integer, List<RankData>> groupRankMap = new HashMap<>();

        Map<Integer, List<CrossArenaTeam>> serverIds = crossTeamArenaService.getAll().stream().collect(Collectors.groupingBy(CrossArenaTeam::getServerId));
        serverIds.forEach((serverId, list) -> {
            CrossGroup group = serverGroupService.getCrossGroup(serverId);
            if (group != null) {
                List<RankData> crossRanks = groupRankMap.computeIfAbsent(group.getGroupId(), key -> new ArrayList<>());
                list.forEach(crossArenaTeam -> {
                    RankData crossRank = new RankData();
                    crossRank.setRankId(crossArenaTeam.getTeamId());
                    crossRank.setRankTime(crossArenaTeam.getRankTime());
                    crossRank.setRankValue(crossArenaTeam.getScore());
                    crossRanks.add(crossRank);
                });
            }
        });

        return groupRankMap;
    }

    @Override
    public List<TeamArenaRankData> getAll(int serverGroup) {
        TopN<Long, RankData> topN = groupTopN.get(serverGroup);
        if (topN == null) {
            return new ArrayList<>();
        }
        List<RankData> top = topN.top(getRankType().getRankCount());
        List<TeamArenaRankData> crossClanRanks = new ArrayList<>();
        top.forEach(crossRank -> {
            CrossArenaTeam crossTeam = crossTeamArenaService.getTeam(crossRank.getRankId());
            crossClanRanks.add(builder(crossTeam, crossRank));
        });
        return crossClanRanks;
    }

    public TeamArenaRankData builder(CrossArenaTeam crossTeam, RankData crossRank) {
        int rank = getEntityRank(crossTeam.getServerId(), crossTeam.getTeamId());
        TeamArenaRankData teamArenaRankData = new TeamArenaRankData();
        if (crossRank == null) {
            teamArenaRankData.setRank(-1);
        } else {
            teamArenaRankData.setRankTime(crossRank.getRankTime());
            teamArenaRankData.setScore((int) crossRank.getRankValue());
            teamArenaRankData.setRank(rank);
        }

        ArenaTeamData data = new ArenaTeamData();
        data.setTeamId(crossTeam.getTeamId());
        data.setServerId(crossTeam.getServerId());
        data.setTeamName(crossTeam.getTeamName());
        data.setCaptainId(crossTeam.getCaptainId());

        List<ArenaTeamMember> members = new ArrayList<>();
        Map<Long, RoleSimpleMessage> simpleMap = new HashMap<>();
        crossTeam.getMembers().forEach(memberTemp -> {
            ArenaTeamMember member = new ArenaTeamMember();
            member.setFighting(memberTemp.getFighting());
            member.setHidden(memberTemp.isHidden());
            member.setRid(memberTemp.getRid());
            members.add(member);

            CrossRole crossRole = crossRoleService.getNotThrow(memberTemp.getRid());
            if (crossRole != null) {
                RoleSimpleMessage simpleMessage = new RoleSimpleMessage();
                simpleMessage.setLevel(crossRole.getLevel());
                simpleMessage.setHeadId(crossRole.getHeadId());
                simpleMessage.setBorderId(crossRole.getBorderId());
                simpleMessage.setImage(crossRole.getImageId());
                simpleMessage.setRoleName(crossRole.getNick());
                simpleMessage.setServerId(crossRole.getServerId());
                simpleMessage.setClanName(crossRole.getClanName());
                simpleMessage.setFighting(crossRole.getFighting());
                simpleMessage.setRid(crossRole.getId());
                simpleMap.put(memberTemp.getRid(), simpleMessage);
            }

        });
        data.setMembers(members);
        data.setSimpleMap(simpleMap);
        teamArenaRankData.setTeamData(data);
        teamArenaRankData.setRankTime(crossRank.getRankTime());
        return teamArenaRankData;
    }

    public List<TeamArenaRankData> builderRankData(int groupId, int from, int to) {
        List<RankData> crossRanks = getGroupTopN(groupId).rangeClosed(from, to);
        List<TeamArenaRankData> list = new ArrayList<>();
        crossRanks.forEach(crossRank -> {
            CrossArenaTeam team = crossTeamArenaService.getTeam(crossRank.getRankId());
            list.add(builder(team, crossRank));
        });
        return list;
    }

    public TeamArenaRankData builderTeam(CrossArenaTeam team) {
        RankData crossRank = getRankEntity(team.getServerId(), team.getTeamId());
        return builder(team, crossRank);

    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CrossRegroupEvent event) {
        log.info("跨服重组，开启新赛季");
        crossTeamArenaService.startNewSeason();
        messageHelper.pushToAll(TeamArenaChangeStateReqMessage.of(crossTeamArenaService.loadTeamArenaTime()));
    }


    @Override
    public void pullToAllGame() {
        if (resetIng)
            return;
        CrossServerGroup crossServerGroup = crossServerGroupService.getCrossServerGroup();
        Set<Integer> set = new HashSet<>(crossServerGroup.getGroups().keySet());
        set.forEach(groupId -> {
//            if (topHadChange.getOrDefault(groupId, true)) {
            topHadChange.put(groupId, false);
            List<TeamArenaRankData> all = getAll(groupId);
            if (CollectionUtil.isNotEmpty(all)) {
                messageHelper.pushToGroupMessage(groupId, TeamArenaGetDataResMessage.createOf(getAll(groupId), true));
//                }
            }
        });
    }

    @Override
    public void pullToGame(int serverId, Connection connection) {
        if (resetIng) {
            return;
        }
        CrossGroup group = serverGroupService.getCrossGroup(serverId);
        if (group == null) {
            log.error("游戏服没有分跨服组，所以没有排行榜数据:{}", serverId);
            return;
        }

        connection.send(TeamArenaGetDataResMessage.createOf(getAll(group.getGroupId()), true));
    }

    /***
     * 这里必须是同步的，要返回排名给游戏服
     * @param event
     */
    @Subscribe
    public void listen(TeamArenaScoreChangeEvent event) {
        RankData crossRank = new RankData();
        CrossArenaTeam crossArenaTeam = event.getTeam();
        crossArenaTeam.setRankTime(TimeDateUtil.getCurrentTimeInt());
        crossTeamArenaService.updateTeam(crossArenaTeam);

        int oldRank = getEntityRank(crossArenaTeam.getServerId(), crossArenaTeam.getTeamId());
        CrossGroup group = serverGroupService.getCrossGroup(crossArenaTeam.getServerId());
        crossRank.setRankId(crossArenaTeam.getTeamId());
        crossRank.setRankTime(crossArenaTeam.getRankTime());
        crossRank.setRankValue(crossArenaTeam.getScore());
        addRank(crossRank, group.getGroupId());

        if (event.isPullToServer()) {
            eventBus.post(TeamArenaRankPullToServerEvent.of(getRankEntity(crossArenaTeam.getServerId(),
                    crossArenaTeam.getTeamId()), group.getGroupId(), oldRank));
        }
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(TeamArenaRankPullToServerEvent event) {
        CrossArenaTeam team = crossTeamArenaService.getTeam(event.getCrossRank().getRankId());
        if (Objects.isNull(team)) {
            return;
        }
        int oldRank = event.getOldRank() <= 0 ? CrossRankType.CROSS_TEAM_ARENA.getRankCount() : event.getOldRank();
        int newRank = getEntityRank(team.getServerId(), team.getTeamId());

        messageHelper.pushToGroupMessage(event.getGroupId(),
                TeamArenaGetDataResMessage.createOf(builderRankData(event.getGroupId(), Math.min(oldRank, newRank),
                        Math.max(oldRank, newRank)), false));
    }
}
