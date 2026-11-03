package com.ayjs.mxzg.gameserver.module.teamArena.service;


import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.domain.Rank;
import com.ayjs.mxzg.gameserver.module.rank.service.AbstractRankService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeam;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.teamArena.domain.ArenaTeamMember;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaRankData;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaGetDataResMessage;
import com.ayjs.mxzg.protocol.TeamArenaGMsg;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

/**
 * @Author: CWJ
 * @Date: 2020/4/9
 **/
@Service
@Slf4j
@Observer
public class TeamArenaRankService extends AbstractRankService<TeamArenaGMsg.PSTeamArenaRank> implements MessageHandler {

    @Autowired
    private TeamArenaService teamArenaService;
    @Autowired
    private RoleService roleService;


    private Map<Long, TeamArenaRankData> crossMapData = null;

    @Override
    protected List<Rank> startLoadRank() {
        List<Rank> list = new ArrayList<>();
        if (crossMapData != null) {
            ImmutableList.copyOf(crossMapData.values()).forEach(teamArenaRankData -> {
                Rank rank = new Rank();
                rank.setRankId(teamArenaRankData.getTeamData().getTeamId());
                rank.setRankTime(teamArenaRankData.getRankTime());
                rank.setRankValue(teamArenaRankData.getScore());
                list.add(rank);
            });
        }
        return list;
    }

    @Override
    public TeamArenaGMsg.PSTeamArenaRank builder(Rank rank) {
        Long teamId = rank.getRankId();
        return teamArenaService.builderRank(crossMapData.get(teamId));
    }

    @Override
    public TeamArenaGMsg.PSTeamArenaRank builderForNotRank(long rankId) {
        TeamArenaGMsg.PSTeamArenaRank.Builder builder = TeamArenaGMsg.PSTeamArenaRank.newBuilder();
        if (rankId == 0) {//未加入队伍
            builder.setRank(-1);
            builder.setTeamId(0);
            return builder.build();
        }
        ArenaTeam team = teamArenaService.get(rankId);
        if (team != null) {
            builder.setRank(-1);
            builder.setTeamId(rankId);
            builder.setScore(team.getScore());
            builder.setTeamName(team.getTeamName());

            int sum = 0;
            for (ArenaTeamMember member : team.getMembers()) {
                TeamArenaGMsg.PBMemberSimpleInfo.Builder memberBuilder = TeamArenaGMsg.PBMemberSimpleInfo.newBuilder();
                memberBuilder.setMember(PbUtil.builderRoleInfo(roleService.getOrThrow(member.getRid())));
                memberBuilder.setHidden(member.isHidden());
                sum += member.getFighting();
                builder.addMember(memberBuilder);
            }

            builder.setCaptainId(team.getCaptainId());
            builder.setFighting(sum);
        }
        return builder.build();
    }

    @Override
    public RankType getRankType() {
        return RankType.TEAM_ARENA;
    }

    public void clearRank() {
        topN.clear();
        crossMapData.clear();
    }

    @RemoteMethod
    public void replaceRank(TeamArenaGetDataResMessage message) {
        try {
            if (message.isReplaceAll()) {
                List<TeamArenaRankData> ranks = message.getRanks() == null ? new ArrayList<>() : message.getRanks();
                log.debug("组队竞技场数量:{}", ranks.size());
                ConcurrentMap crossMapData_ = new ConcurrentHashMap<>();
                ranks.forEach(teamArenaRankData -> crossMapData_.put(teamArenaRankData.getTeamData().getTeamId(), teamArenaRankData));
                crossMapData = crossMapData_;
                start();

            } else {
                if (CollectionUtil.isNotEmpty(message.getRanks())) {
                    message.getRanks().sort(new Comparator<TeamArenaRankData>() {
                        @Override
                        public int compare(TeamArenaRankData o1, TeamArenaRankData o2) {
                            return o2.getRank() - o1.getRank();
                        }
                    });
                    message.getRanks().forEach(rankData -> {
                        crossMapData.put(rankData.getTeamData().getTeamId(), rankData);
                        Rank rank = new Rank();
                        rank.setRankId(rankData.getTeamData().getTeamId());
                        rank.setRankTime(rankData.getRankTime());
                        rank.setRankValue(rankData.getScore());

                        topN.add(rank);
                    });
                }
            }

        } catch (Exception e) {
            log.error("重载排行榜异常", e);
        }

    }

    @Override
    public TeamArenaGMsg.PSTeamArenaRank selfRank(long rankId) {
        TeamArenaGMsg.PSTeamArenaRank.Builder builder = TeamArenaGMsg.PSTeamArenaRank.newBuilder();
        if (rankId == 0) {//未加入队伍
            builder.setRank(-1);
            builder.setTeamId(0);
            return builder.build();
        }
        ArenaTeam team = teamArenaService.get(rankId);
        if (team != null) {
            int rank = getRank(rankId);
            builder.setRank(rank <= 0 ? -1 : rank);
            builder.setTeamId(rankId);
            builder.setScore(team.getScore());
            builder.setTeamName(team.getTeamName());

            int sum = 0;
            for (ArenaTeamMember member : team.getMembers()) {
                TeamArenaGMsg.PBMemberSimpleInfo.Builder memberBuilder = TeamArenaGMsg.PBMemberSimpleInfo.newBuilder();
                memberBuilder.setMember(PbUtil.builderRoleInfo(roleService.getOrThrow(member.getRid())));
                memberBuilder.setHidden(member.isHidden());
                sum += member.getFighting();
                builder.addMember(memberBuilder);
            }

            builder.setCaptainId(team.getCaptainId());
            builder.setFighting(sum);
        }
        return builder.build();
    }
}
