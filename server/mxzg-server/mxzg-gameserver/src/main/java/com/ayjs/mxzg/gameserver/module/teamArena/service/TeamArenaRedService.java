package com.ayjs.mxzg.gameserver.module.teamArena.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.cache.teamArena.TeamArenaChallengeRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.teamArena.CTeamArenaChallengeReward;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.teamArena.constant.TeamArenaRedConst;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeam;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeamApply;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeamInvite;
import com.ayjs.mxzg.gameserver.module.teamArena.event.TeamArenaStateChangeEvent;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaState;
import com.ayjs.mxzg.protocol.TeamArenaGMsg;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/4/21
 **/
@Service
@Slf4j
@Observer
public class TeamArenaRedService {
    @Autowired
    private TeamArenaService teamArenaService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private OpenConditionSysCache openConditionSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private TeamArenaChallengeRewardSysCache teamArenaChallengeRewardSysCache;

    public void sendRedState(long rid) {
        try {
            PlayerContext online = contextManager.getOnline(rid);
            Role role = roleService.getOrThrow(rid);
            if (Objects.isNull(online) ||
                    openConditionSysCache.getCondition(EntryType.MAIN_TEAM_ARENA).getCondition_value() > role.getLevel()) {
                return;
            }
            TeamArenaGMsg.GResTeamArenaRedState.Builder builder = TeamArenaGMsg.GResTeamArenaRedState.newBuilder();
            ArenaTeam team = teamArenaService.getTeamByRid(rid);
            //收到申请小红点
            if (Objects.nonNull(team) && team.getCaptainId() == rid &&
                    team.getMembers().size() < teamArenaService.getMemberMaxNum()) {
                List<ArenaTeamApply> applies = teamArenaService.getAppliesByTeamId(team.getTeamId());
                if (applies.size() > 0) {
                    builder.addRedList(TeamArenaRedConst.APPLY_RED);
                }
            }
            //收到邀请小红点
            List<ArenaTeamInvite> invites = teamArenaService.getInvitesByRid(rid);
            if (invites.size() > 0) {
                builder.addRedList(TeamArenaRedConst.INVITE_RED);
            }

            if (Objects.nonNull(team)) {
                //挑战小红点
                if (team.getCanChallengeCount() > 0 && team.getCaptainId() == rid && team.isHadSign()
                        && teamArenaService.loadTeamArenaTime().getCurrState() == TeamArenaState.CHALLENGE) {
                    builder.addRedList(TeamArenaRedConst.CHALLENGE_RED);
                }

                //领奖小红点
                Set<Integer> rewards = team.getMemberReward().getOrDefault(rid, Collections.emptySet());

                List<CTeamArenaChallengeReward> list = teamArenaChallengeRewardSysCache.getAll().stream().
                        filter(config -> config.getNeed_count() <= team.getHadChallengeCount()
                                && !rewards.contains(config.getIdx())).collect(Collectors.toList());
                if (list.size() > 0) {
                    builder.addRedList(TeamArenaRedConst.REWARD_RED);
                }
            }

            online.write(CmdCode._66020, builder.build());
        } catch (Exception e) {
            log.error("小红点状态错误！", e);
        }
    }

    @Subscribe
    public void listener(TeamArenaStateChangeEvent event) {
        ImmutableList.copyOf(contextManager.getOnlineRids()).forEach(rid -> {
            if (rid > 0){
                sendRedState(rid);
            }
        });
    }
}
