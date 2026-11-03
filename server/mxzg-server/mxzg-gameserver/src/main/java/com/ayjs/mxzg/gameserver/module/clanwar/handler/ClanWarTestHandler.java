/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clanwar.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.ClanJobEnum;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanMember;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.BattleGMsg.PSLineUpData;
import com.ayjs.mxzg.protocol.BattleGMsg.PSLineUpHeroData;
import com.ayjs.mxzg.protocol.ClanWarGMsg.GReqSaveRoadFormation;
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
public class ClanWarTestHandler {
	
	@Autowired
	private RoleService roleService;
	@Autowired
	private ClanService clanService;
	@Autowired
	private HeroLineUpService heroLineUpService;
	@Autowired
	private HeroTypeSysCache heroTypeSysCache;
	@Autowired
	private HeroService heroService;
	@Autowired
	private EventBus eventBus;
	@Autowired
	private ClanWarHandler clanWarCrossHandler;
	@Autowired
	private ServerConfig serverConfig;
	
	/**
	 * 构建公会战测试环境
	 */
	public void buildTestEnviroment() {
		//创建两个公会
		buildTestClan();
		buildTestClan();
	}
	
	
	private void buildTestClan() {
		Role leader = new Role();
		leader.setNick(roleService.randomNick(null));
		leader.setLastOfflineTime(TimeDateUtil.getCurrentTime());
		leader.setLevel(70);
		leader.setServerId(serverConfig.getServerId());
		leader.setIsEditName(1);
		roleService.addRole(leader);
		
		Clan clan = clanService.insertClan("公会test" + roleService.randomNick(null), "呵呵", 1, leader.getId(), leader.getNick());
		
		leader.setClanId(clan.getId());
		roleService.updateRole(leader);
		clanService.insertClanMember(clan.getId(), clan.getClanName(), leader.getId(), ClanJobEnum.CLAN_PRESIDENT.getJobKey());
		
		buildTestLineUp(leader);
		
		for(int i = 0; i < 15; i++) {
			Role member = new Role();
			member.setNick(roleService.randomNick(null));
			member.setLastOfflineTime(TimeDateUtil.getCurrentTime());
			member.setLevel(70);
			member.setClanId(clan.getId());
			member.setIsEditName(1);
			member.setServerId(serverConfig.getServerId());
			roleService.addRole(member);
			
			clanService.insertClanMember(clan.getId(), clan.getClanName(), member.getId(), ClanJobEnum.CLAN_PRESIDENT.getJobKey());
			
			buildTestLineUp(member);
		}
	}
	
	private void buildTestLineUp(Role role) {
		List<Hero> heroList = new ArrayList<>();
		int index = RandomUtil.getRandomInt(0, heroTypeSysCache.getAll().size() - 1);
		for(int i = 0; i < 6; i++) {
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
	
	public void buildMemberAutoRoad() {
		List<Clan> clanList = clanService.selectAll();
		for(Clan clan : clanList) {
			for(ClanMember member : clanService.selectClanMember(clan.getId())) {
				try {
					PlayerContext playerContext = new PlayerContext(null);
					playerContext.setId(member.getRid());
					
//					HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(member.getRid(), LineUpType.CLAN_WAR);
//					long heroId = 0;
//					for(HeroPosition heroPos : heroLineUp.getFormationMap().values()) {
//						if(heroPos.getPos() == 1) {
//							heroId = heroPos.getHeroId();
//							break;
//						}
//					}
//					heroLineUp.getFormationMap().remove(heroId);
//					heroLineUpService.updateHeroLineUp(heroLineUp);
					
					GReqSaveRoadFormation.Builder builder = GReqSaveRoadFormation.newBuilder();
					builder.setRoad(RandomUtil.getRandomInt(1, 3));
					clanWarCrossHandler.saveRoadFormation(playerContext, builder.build());
				} catch (Exception e) {
					log.error("自动布置路线失败");
				}
			}
		}
	}
	
}
