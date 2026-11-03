/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.stagematch.pinnacle.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpDefEvent;
import com.ayjs.mxzg.gameserver.module.rank.service.impl.ArenaRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.BattleGMsg.PSLineUpData;
import com.ayjs.mxzg.protocol.BattleGMsg.PSLineUpHeroData;
import com.ayjs.mxzg.protocol.PvpGMsg.PSRankPlayerData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;

/**
 * @author YY
 *
 */
@Controller
public class PinnacleTestHandler {

	@Autowired
	private RoleService roleService;
	@Autowired
	private HeroLineUpService heroLineUpService;
	@Autowired
	private HeroTypeSysCache heroTypeSysCache;
	@Autowired
	private HeroService heroService;
	@Autowired
	private EventBus eventBus;
	@Autowired
	private ArenaRankService arenaRankService;
	
	public void buildTestEnviroment() {
		for(int i = 0; i < 140; i++) {
			Role member = new Role();
			member.setNick(roleService.randomNick(null));
			member.setLastOfflineTime(TimeDateUtil.getCurrentTime());
			member.setLevel(70);
			member.setClanId(0);
			member.setIsEditName(1);
			member.setArenaScore(RandomUtil.getRandomInt(850, 2450));
			roleService.addRole(member);
			
			buildTestLineUp(member);
			
			eventBus.post(PvpDefEvent.of(member.getId(), member.getArenaScore()));
		}
		List<PSRankPlayerData> list = arenaRankService.showRanks(9999);
		System.out.println(list.size());
	}
	
	private void buildTestLineUp(Role role) {
		List<Hero> heroList = new ArrayList<>();
		for(int i = 0; i < 6; i++) {
			int index = RandomUtil.getRandomInt(0, heroTypeSysCache.getAll().size() - 1);
			CHeroType cHeroType = heroTypeSysCache.getAll().get(index);
			
			Hero hero = new Hero();
    		hero.setRid(role.getId());
    		hero.setType(cHeroType.getType());
    		hero.setStage(6);
    		hero.setStar(10);
    		hero.setLevel(100);
    		hero.setFighting(123456);
    		hero.setCreateTime(TimeDateUtil.getCurrentTimeInt());
    		heroList.add(hero);
		}
		heroService.addHeros(heroList);
        eventBus.post(HeroGetEvent.of(role.getId(), heroList, GameEvent.GM));
        
        PSLineUpData.Builder builder = PSLineUpData.newBuilder();
        for(int i = 0; i < heroList.size(); i++) {
        	Hero hero = heroList.get(i);
        	PSLineUpHeroData.Builder pos = PSLineUpHeroData.newBuilder();
        	pos.setHeroId(hero.getId());
        	pos.setPosition(i + 1);
        	builder.addHeroList(pos.build());
        }
        builder.setType(LineUpType.CLAN_WAR.getValue());
        heroLineUpService.saveLineUpFormation(role.getId(), builder.build());
        
        builder.setType(LineUpType.MAIN.getValue());
        heroLineUpService.saveLineUpFormation(role.getId(), builder.build());
	}
	
}
