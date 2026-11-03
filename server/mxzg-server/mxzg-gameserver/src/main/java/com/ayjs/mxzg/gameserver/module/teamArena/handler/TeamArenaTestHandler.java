/**
 *
 */
package com.ayjs.mxzg.gameserver.module.teamArena.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.fetter.domain.FetterGoddess2;
import com.ayjs.mxzg.gameserver.module.fetter.service.FetterService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeam;
import com.ayjs.mxzg.gameserver.module.teamArena.service.TeamArenaService;
import com.ayjs.mxzg.protocol.BattleGMsg.PSLineUpData;
import com.ayjs.mxzg.protocol.BattleGMsg.PSLineUpHeroData;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
public class TeamArenaTestHandler {

    @Autowired
    private RoleService roleService;
    @Autowired
    private TeamArenaService teamArenaService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private HeroService heroService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private FetterService fetterService;

    @Autowired
    private ServerConfig serverConfig;

    /**
     * 构建公会战测试环境
     */
    public void buildTestEnviroment() {
        //创建两个队伍
        buildTestTeam(null);
        buildTestTeam(null);
    }


    public void buildTestTeam(Role role) {
        Role leader = null;
        if (role == null) {
            leader = new Role();
            leader.setNick(roleService.randomNick(null));
            leader.setLastOfflineTime(TimeDateUtil.getCurrentTime());
            leader.setLevel(100);
            leader.setServerId(serverConfig.getServerId());
            leader.setIsEditName(1);
            roleService.addRole(leader);
            roleService.sendToCrossImmediately(leader.getId(), null);
        } else {
            leader = role;
        }
        ArenaTeam team = teamArenaService.getTeamByRid(leader.getId());
        if (team != null) {
            return;
        }
        buildTestLineUp(leader);
        team = teamArenaService.doCreate("队伍名:" + leader.getNick(), true, 0, 0, leader.getId());
        for (int i = 0; i < 2; i++) {
            Role member = new Role();
            member.setNick(roleService.randomNick(null));
            member.setLastOfflineTime(TimeDateUtil.getCurrentTime());
            member.setLevel(70);
            member.setIsEditName(1);
            member.setServerId(serverConfig.getServerId());
            roleService.addRole(member);
            roleService.sendToCrossImmediately(member.getId(), null);
            buildTestLineUp(member);
            teamArenaService.doJoinTeam(member.getId(), team);
        }
    }

    private void buildTestLineUp(Role role) {
        List<Hero> heroList = new ArrayList<>();
        int index = RandomUtil.getRandomInt(0, heroTypeSysCache.getAll().size() - 1);
        for (int i = 0; i < 6; i++) {
            CHeroType cHeroType = heroTypeSysCache.getAll().get((index + i) % heroTypeSysCache.getAll().size());

            Hero hero = new Hero();
            hero.setRid(role.getId());
            hero.setType(cHeroType.getType());
            hero.setStage(6);
            hero.setStar(10);
            hero.setLevel(100);
            hero.setFighting(123456);
            hero.setCreateTime(TimeDateUtil.getCurrentTimeInt());
            hero.setName(cHeroType.getNote());
            heroList.add(hero);
        }
        heroService.addHeros(heroList);
        eventBus.post(HeroGetEvent.of(role.getId(), heroList, GameEvent.GM));

        PSLineUpData.Builder builder = PSLineUpData.newBuilder();
        for (int i = 0; i < heroList.size(); i++) {
            Hero hero = heroList.get(i);
            PSLineUpHeroData.Builder pos = PSLineUpHeroData.newBuilder();
            pos.setHeroId(hero.getId());
            pos.setPosition(i + 1);
            builder.addHeroList(pos.build());
        }
        builder.setType(LineUpType.TEAM_ARENA.getValue());
        builder.setFormationId(1);
        FetterGoddess2 load = fetterService.load(role.getId());
        if (load.getActiveType().size() > 0){
            Integer integer = load.getActiveType().stream().findFirst().orElse(0);
            builder.setGoddessType(integer);
        }
        heroLineUpService.saveLineUpFormation(role.getId(), builder.build());

        builder.setType(LineUpType.MAIN.getValue());
        heroLineUpService.saveLineUpFormation(role.getId(), builder.build());
    }


}
