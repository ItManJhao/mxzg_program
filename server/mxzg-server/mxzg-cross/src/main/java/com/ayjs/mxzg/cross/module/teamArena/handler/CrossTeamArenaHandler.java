package com.ayjs.mxzg.cross.module.teamArena.handler;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.config.excel.cache.teamArena.TeamArenaScoreSysCache;
import com.ayjs.mxzg.config.excel.entity.teamArena.CTeamArenaScore;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.SessionManager;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.cross.module.rank.service.impl.CrossTeamArenaRankService;
import com.ayjs.mxzg.cross.module.teamArena.domain.CrossArenaTeam;
import com.ayjs.mxzg.cross.module.teamArena.domain.TeamArenaSettleRecord;
import com.ayjs.mxzg.cross.module.teamArena.event.TeamArenaScoreChangeEvent;
import com.ayjs.mxzg.cross.module.teamArena.service.CrossTeamArenaService;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.message.module.teamArena.domain.ArenaTeamMember;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaRankData;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaTime;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaBattleReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaBattleResMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaChangeStateReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaDefendResMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaGMReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaGetStateReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaRefreshDefendReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaRefreshDefendResMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaSettleRecordReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaSettleRecordResMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaSignReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaSignResMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaUpdateTeamReqMessage;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import com.ayjs.rpc.server.ConnectionManager;
import com.google.common.collect.Lists;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/4/10
 **/
@Component
@Slf4j
public class CrossTeamArenaHandler implements MessageHandler {

    @Autowired
    private CrossTeamArenaService crossTeamArenaService;
    @Autowired
    private CrossTeamArenaRankService crossTeamArenaRankService;
    @Autowired
    private CrossServerGroupService crossServerGroupService;
    @Autowired
    private CrossRoleService crossRoleService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private TeamArenaScoreSysCache teamArenaScoreSysCache;
    @Autowired
    private ConnectionManager connectionManager;
    @Autowired
    private SessionManager sessionManager;

    private static final String TEAM_ARENA_SCORE_LOCK = "TEAM_ARENA_SCORE";

    @RemoteMethod
    public TeamArenaSignResMessage sign(TeamArenaSignReqMessage req) {
        CrossRole crossRole = crossRoleService.getOrThrow(req.getCaptainId());
        int groupId = crossServerGroupService.getGroupId(crossRole.getServerId());

        CrossArenaTeam team = doCreateTeam(req.getTeamId(), req.getCaptainId(), req.getTeamName(), req.getMembers(), req.getCreateTime());
        eventBus.post(TeamArenaScoreChangeEvent.of(team, true));

        List<TeamArenaRankData> list = matchDefend(team, groupId);
        return TeamArenaSignResMessage.createOf(list);

    }

    private CrossArenaTeam doCreateTeam(long teamId, long captainId, String teamName, List<ArenaTeamMember> members, int createTime) {
        CrossArenaTeam team = new CrossArenaTeam();
        team.setTeamId(teamId);
        team.setCaptainId(captainId);
        team.setTeamName(teamName);
        team.setServerId(crossRoleService.getOrThrow(team.getCaptainId()).getServerId());
        team.getMembers().addAll(members);
        team.setScore(1000);
        team.setCreateTime(createTime);
        crossTeamArenaService.add(team);
        return team;
    }

    @RemoteMethod
    public TeamArenaRefreshDefendResMessage refreshDefend(TeamArenaRefreshDefendReqMessage req) {
        CrossArenaTeam team = crossTeamArenaService.getTeam(req.getTeamId());
        int groupId = crossServerGroupService.getGroupId(team.getServerId());
        List<TeamArenaRankData> list = matchDefend(team, groupId);
        return TeamArenaRefreshDefendResMessage.createOf(list);
    }

    private List<TeamArenaRankData> matchDefend(CrossArenaTeam team, int groupId) {
        List<TeamArenaRankData> list = new ArrayList<>();

        int rank = crossTeamArenaRankService.getEntityRank(team.getServerId(), team.getTeamId());
        if (rank <= 0) {
            rank = CrossRankType.CROSS_TEAM_ARENA.getRankCount();
        }

        List<Integer> rankRange = new ArrayList<>();
        for (int i = 1; i <= 10; i++) {
            if (rank - i >= 1) {
                rankRange.add(rank - i);
            }
            if (rank + i <= CrossRankType.CROSS_TEAM_ARENA.getRankCount()) {
                rankRange.add(rank + i);
            }
        }
        Collections.shuffle(rankRange);
        int index = 0;
        while (list.size() < 3 && rankRange.size() > index) {
            RankData crossRank = crossTeamArenaRankService.getRank(groupId, rankRange.get(index));
            index++;
            if (crossRank == null || crossRank.getRankId() == team.getTeamId()) {
                continue;
            }
            list.add(crossTeamArenaRankService.builderTeam(crossTeamArenaService.getTeam(crossRank.getRankId())));

        }
        return list;
    }

    @RemoteMethod
    public TeamArenaBattleResMessage battle(TeamArenaBattleReqMessage req, Connection connection) {
        CrossArenaTeam attackTeam = crossTeamArenaService.getTeam(req.getTeamId());
        CrossArenaTeam defendTeam = crossTeamArenaService.getTeam(req.getDefendTeamId());
        int old = crossTeamArenaRankService.getEntityRank(attackTeam.getServerId(), attackTeam.getTeamId());
        int oldDef = crossTeamArenaRankService.getEntityRank(defendTeam.getServerId(), defendTeam.getTeamId());
        int newRank = old;
        int newDefendRank = oldDef;
        int addScore = 0;
        int defReduceScore = 0;
        if (req.isWin()) {
            long minTeamId = attackTeam.getTeamId() < defendTeam.getTeamId() ? attackTeam.getTeamId() : defendTeam.getTeamId();
            long maxTeamId = attackTeam.getTeamId() < defendTeam.getTeamId() ? defendTeam.getTeamId() : attackTeam.getTeamId();
            synchronized (InternerPool.intern(TEAM_ARENA_SCORE_LOCK, minTeamId)) {
                synchronized (InternerPool.intern(TEAM_ARENA_SCORE_LOCK, maxTeamId)) {
                    old = crossTeamArenaRankService.getEntityRank(attackTeam.getServerId(), attackTeam.getTeamId());
                    oldDef = crossTeamArenaRankService.getEntityRank(defendTeam.getServerId(), defendTeam.getTeamId());

                    int attackScore = attackTeam.getScore();
                    int defendScore = defendTeam.getScore();

                    int intervalScore = attackScore - defendScore;
                    List<CTeamArenaScore> minusSortList = teamArenaScoreSysCache.getMinusSortList();
                    CTeamArenaScore scoreConfig = teamArenaScoreSysCache.getMinusSortList().get(minusSortList.size() - 1);
                    for (int i = minusSortList.size() - 1; i >= 0; i--) {
                        if (minusSortList.get(i).getMinus() <= intervalScore) {
                            break;
                        }
                        scoreConfig = minusSortList.get(i);
                    }

                    addScore = scoreConfig.getGet_score();
                    defReduceScore = -scoreConfig.getLose_score();
                    attackTeam.setScore(attackTeam.getScore() + addScore);
                    defendTeam.setScore(defendTeam.getScore() + defReduceScore);

                    crossTeamArenaService.updateTeam(attackTeam);
                    crossTeamArenaService.updateTeam(defendTeam);

                    eventBus.post(TeamArenaScoreChangeEvent.of(attackTeam, true));
                    eventBus.post(TeamArenaScoreChangeEvent.of(defendTeam, false));
                    crossTeamArenaRankService.pullToGame(attackTeam.getServerId(), connection);

                    newRank = crossTeamArenaRankService.getEntityRank(attackTeam.getServerId(), attackTeam.getTeamId());
                    newDefendRank = crossTeamArenaRankService.getEntityRank(attackTeam.getServerId(), req.getDefendTeamId());

                    Integer clientId = sessionManager.getClientIdBy(defendTeam.getServerId());
                    connectionManager.send(clientId, TeamArenaDefendResMessage.of(defendTeam.getTeamId(), newDefendRank, defendTeam.getScore()));
                }
            }
        }
        TeamArenaBattleResMessage res = new TeamArenaBattleResMessage();

        res.setRank(newRank);
        res.setAddRank(old - newRank);
        res.setScore(attackTeam.getScore());
        res.setDefendNewRank(newDefendRank);
        res.setDefendAddRank(oldDef - newDefendRank);
        res.setAddScore(addScore);
        res.setDefReduceScore(defReduceScore);
        res.setDefScore(defendTeam.getScore());
        return res;
    }

    @RemoteMethod
    public void gmSetState(TeamArenaGMReqMessage req) {
        crossTeamArenaService.setState(req.getState(), false);
    }

    @RemoteMethod
    public void update(TeamArenaUpdateTeamReqMessage req) {
        List<CrossArenaTeam> needUpdates = new ArrayList<>();
        TeamArenaTime teamArenaTime = crossTeamArenaService.loadTeamArenaTime();
        if (CollectionUtil.isEmpty(req.getUpdates())) {
            return;
        }
        req.getUpdates().forEach(teamData -> {
            CrossArenaTeam team = crossTeamArenaService.getTeam(teamData.getTeamId());
            if (Objects.nonNull(team)) {
                team.getMembers().clear();
                team.getMembers().addAll(teamData.getMembers());
                team.setTeamName(teamData.getTeamName());
                team.setCaptainId(teamData.getCaptainId());
                needUpdates.add(team);
            } else {
                if (teamData.getCreateTime() > teamArenaTime.getRemoveTeamTime()) {
                    team = doCreateTeam(teamData.getTeamId(), teamData.getCaptainId(), teamData.getTeamName(),
                            teamData.getMembers(), teamData.getCreateTime());

                    eventBus.post(TeamArenaScoreChangeEvent.of(team, true));
                }
            }
        });
        if (!needUpdates.isEmpty()) {
            crossTeamArenaService.updateTeams(needUpdates);
        }
    }

    @RemoteMethod
    public TeamArenaSettleRecordResMessage getRecord(TeamArenaSettleRecordReqMessage req) {
        List<TeamArenaSettleRecord> records = Lists.newArrayList();
        for (int serverId : req.getServerId()) {
            records.addAll(crossTeamArenaService.getByServerId(serverId, req.getSettleTime()));
        }
        records.sort(new Comparator<TeamArenaSettleRecord>() {
            @Override
            public int compare(TeamArenaSettleRecord o1, TeamArenaSettleRecord o2) {
                return o2.getSettleTime() - o1.getSettleTime();
            }
        });
        if (records.size() <= 0) {
            log.info("领奖不存在不存在:" + req.getServerId());
            return TeamArenaSettleRecordResMessage.of(new ArrayList<>(), req.getSettleTime());
        }


        List<TeamArenaRankData> ranks = new ArrayList<>();
        int settleTime = req.getSettleTime();
        for (TeamArenaSettleRecord record : records) {
            ranks.addAll(record.getRanks());
            settleTime = Math.max(settleTime, record.getSettleTime());
        }

        return TeamArenaSettleRecordResMessage.of(ranks, settleTime);
    }

    @RemoteMethod
    public TeamArenaChangeStateReqMessage getState(TeamArenaGetStateReqMessage req) {
        return TeamArenaChangeStateReqMessage.of(crossTeamArenaService.loadTeamArenaTime());
    }
}
