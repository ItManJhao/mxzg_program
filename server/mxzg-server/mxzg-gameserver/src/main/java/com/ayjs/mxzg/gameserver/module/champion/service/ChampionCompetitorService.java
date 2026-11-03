/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.champion.service;

import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.config.excel.cache.ChampionRobotRoleSysCache;
import com.ayjs.mxzg.config.excel.cache.ChampionRobotSysCache;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.constant.ChampionConst;
import com.ayjs.mxzg.config.excel.entity.CChampionRobot;
import com.ayjs.mxzg.config.excel.entity.CChampionRobotRole;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.champion.dao.ChampionCompetitorDao;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionCompetitor;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionSystem;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.rank.service.impl.ArenaRankService;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.module.champion.ChampionTemplate;
import com.ayjs.mxzg.protocol.PvpGMsg.PSRankPlayerData;
import com.ayjs.mxzg.template.constant.GameConstant;
import com.ayjs.mxzg.template.language.LanguageHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * @author YY
 *
 */
@Slf4j
@Service
public class ChampionCompetitorService {
	
	@Autowired
	private BattleHelper battleHelper;
	@Autowired
	private HeroLineUpService heroLineUpService;
	@Autowired
	private ArenaRankService arenaRankService;
	@Autowired
	private ChampionCompetitorDao championCompetitorDao;
	@Autowired
	private ChampionRobotRoleSysCache championRobotRoleSysCache;
	@Autowired
	private ChampionRobotSysCache championRobotSysCache;
	@Autowired
	private LanguageSysCache languageSysCache;
	@Autowired
	private LanguageHelper languageHelper;
	@Autowired
	private BattleTemplate battleTemplate;
	@Autowired
	private ServerConfig serverConfig;

	public List<ChampionCompetitor> getByRound(int round) {
		return championCompetitorDao.list("round", round);
	}
	
	public void update(ChampionCompetitor championCompetitor) {
		championCompetitorDao.update(championCompetitor);
	}
	
	public void updateList(List<ChampionCompetitor> list) {
		championCompetitorDao.update(list);
	}
	
	public void insertList(List<ChampionCompetitor> list) {
		championCompetitorDao.add(list);
	}
	
	public List<ChampionCompetitor> initCompetitor(ChampionSystem championSystem) {
		List<PSRankPlayerData> rankPlayers = arenaRankService.showRanks(ChampionConst.TRIALS_PLAYER);
		
		List<ChampionCompetitor> competitors = new ArrayList<>();
		for(PSRankPlayerData playerData : rankPlayers) {
			log.info("本届冠军赛入围玩家{}-{}，竞技场积分{}", playerData.getPlayerId(), playerData.getName(), playerData.getScore());
			
			ChampionCompetitor competitor = createCompetitor(playerData, championSystem);
			if(competitor != null) {
				competitors.add(competitor);
			}
		}
		//补足机器人
		List<CChampionRobotRole> robotList = new ArrayList<>(championRobotRoleSysCache.getAll());
		Collections.shuffle(robotList);
		int playerCount = competitors.size();
		log.info("本届冠军赛需补充机器人{}个", ChampionConst.TRIALS_PLAYER - playerCount);
		for(int i = 0; i < ChampionConst.TRIALS_PLAYER - playerCount; i++) {
			//机器人数据
			CChampionRobotRole robotRole = robotList.get(i);
			ChampionCompetitor robot = createRobotCompetitor(robotRole, championSystem);
	        competitors.add(robot);
		}
		//初始化选拔赛分组
		ChampionTemplate.initTrials(competitors);
		//插入数据
		insertList(competitors);
		return competitors;
	}
	
	/**
	 * 创建参赛者数据
	 * @param playerData
	 * @param championSystem
	 * @return
	 */
	private ChampionCompetitor createCompetitor(PSRankPlayerData playerData, ChampionSystem championSystem) {
		LineUpType lineUpType = LineUpType.CHAMPION;
		HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(playerData.getPlayerId(), lineUpType);
		if(heroLineUp.getFormationMap().isEmpty()) {
			lineUpType = LineUpType.MAIN;
			heroLineUp = heroLineUpService.getLineUpByType(playerData.getPlayerId(), lineUpType);
		}
		if(heroLineUp.getFormationMap().isEmpty()) {
			//主线阵容都空的话就不能参与冠军赛
			return null;
		}
		BattlerDo battlerDo = battleHelper.queryPlayerBattler(lineUpType, playerData.getPlayerId(), Faction.ATTACKER);
        BattlerVo battlerVo = battlerDo.toBattlerVo();
        
        int fighting = heroLineUpService.getLineUpFighting(heroLineUp);
		
		ChampionCompetitor competitor = new ChampionCompetitor();
		competitor.setRid(playerData.getPlayerId());
		competitor.setName(playerData.getName());
		competitor.setOriPoint((int)(playerData.getScore() * ChampionConst.ORIPOINT_RATE * 1.0f / GameConstant.WAN));
		competitor.setPoint(competitor.getOriPoint());
		competitor.setFighting(fighting);
		competitor.setBattlerVo(battlerVo);
		competitor.setRound(championSystem.getRound());
		competitor.setLevel(playerData.getLevel());
		competitor.setHeadId(playerData.getHeadId());
		competitor.setBorderId(playerData.getBorderId());
		competitor.setServerId(playerData.getServerId());
		return competitor;
	}
	
	/**
	 * 创建机器人数据
	 * @param robotRole
	 * @param championSystem
	 * @return
	 */
	private ChampionCompetitor createRobotCompetitor(CChampionRobotRole robotRole, ChampionSystem championSystem) {
		List<CChampionRobot> teamList = championRobotSysCache.getByTeam(robotRole.getTeam());

		CLanguage cLanguage = languageSysCache.getByKey(robotRole.getName_lang());
		String robotName = languageHelper.getLanguageBy(cLanguage);
		
		//机器人战斗数据
		BattlerDo battlerDo = battleHelper.queryNpcBattler(teamList, robotName);
        BattlerVo battlerVo = battlerDo.toBattlerVo();
        battlerVo.setPlayerId(robotRole.getTeam());
        //机器人战力
		int fighting = battleTemplate.computeMonsterStrength(teamList);
        
        ChampionCompetitor robot = new ChampionCompetitor();
        robot.setRid(robotRole.getTeam());
        robot.setName(robotName);
        robot.setOriPoint((int)(robotRole.getCup() * ChampionConst.ORIPOINT_RATE * 1.0f / GameConstant.WAN));
        robot.setPoint(robot.getOriPoint());
        robot.setFighting(fighting);
        robot.setBattlerVo(battlerVo);
        robot.setRound(championSystem.getRound());
        robot.setRobot(1);
        robot.setLevel(robotRole.getLevel());
        robot.setHeadId(robotRole.getHead());
        robot.setBorderId(0);
        robot.setServerId(serverConfig.getServerId());
        return robot;
	}
}
