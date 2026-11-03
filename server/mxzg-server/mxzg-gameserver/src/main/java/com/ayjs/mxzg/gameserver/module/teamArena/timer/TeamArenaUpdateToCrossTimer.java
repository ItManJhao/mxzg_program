package com.ayjs.mxzg.gameserver.module.teamArena.timer;

import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.LineUpChangeEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeam;
import com.ayjs.mxzg.gameserver.module.teamArena.service.TeamArenaService;
import com.ayjs.mxzg.message.module.teamArena.domain.ArenaTeamMember;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Objects;
import java.util.Set;

/**
 * @Author: CWJ
 * @Date: 2020/4/14
 **/
@Service
public class TeamArenaUpdateToCrossTimer extends AbstractCronTask {

    @Autowired
    private TeamArenaService teamArenaService;
    @Autowired
    private HeroLineUpService heroLineUpService;

    @Override
    public Object identity() {
        return "TeamArenaUpdateToCrossTimer";
    }

    @Override
    public String expression() {
        return "0 */1 * * * ?";
    }

    private Set<Long> teamIds = new HashSet<>();

    @Override
    public void run() {
        if (teamIds.isEmpty()) {
            return;
        }
        Set<Long> teamIds_ = new HashSet<>();
        teamIds_.addAll(teamIds);
        teamIds = new HashSet<>();
        List<ArenaTeam> updates = new ArrayList<>();

        teamIds_.forEach(teamId -> {
            ArenaTeam team = teamArenaService.get(teamId);
            if (team != null && team.isHadSign()) {
                updates.add(team);
            }
        });
        if (!updates.isEmpty()) {
            teamArenaService.updateToCross(updates);
        }
    }

    @Subscribe
    public void heroFightChange(HeroFightChangeEvent event) {
        ArenaTeam team = teamArenaService.getTeamByRid(event.getHero().getRid());
        HeroLineUp lineUp = teamArenaService.getLineUp(event.getHero().getRid());
        if (Objects.nonNull(team) && lineUp.getFormationMap().containsKey(event.getHero().getId())) {
            doUpdateTeamFighting(team, event.getHero().getRid());
        }
    }

    private void doUpdateTeamFighting(ArenaTeam team, long rid) {
        ArenaTeamMember member = team.getMembers().stream().filter(member_ -> member_.getRid() == rid).findFirst().orElse(null);
        if (Objects.nonNull(member)) {
            int fight = heroLineUpService.getLineUpFighting(teamArenaService.getLineUp(member.getRid()));
            if (fight != member.getFighting()) {
                member.setFighting(fight);
            }
            teamArenaService.update(team);

            if (team.isHadSign()) {
                teamIds.add(team.getTeamId());
            }
        }
    }

    @Subscribe
    public void listen(LineUpChangeEvent event) {
        if (Objects.nonNull(event.getHeroLineUp()) && event.getHeroLineUp().getType() == LineUpType.TEAM_ARENA.getValue()) {
            ArenaTeam team = teamArenaService.getTeamByRid(event.getHeroLineUp().getRid());
            if (Objects.nonNull(team)) {
                doUpdateTeamFighting(team, event.getHeroLineUp().getRid());
            }
        }
    }
}
