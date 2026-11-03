/**
 * 
 */
package com.ayjs.mxzg.cross.module.champion.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.config.excel.cache.ChampionCrossPointSysCache;
import com.ayjs.mxzg.config.excel.cache.ServerLadderRobotSysCache;
import com.ayjs.mxzg.config.excel.constant.ChampionConst;
import com.ayjs.mxzg.config.excel.entity.CChampionCrossPoint;
import com.ayjs.mxzg.config.excel.entity.CServerLadderRobot;
import com.ayjs.mxzg.cross.module.champion.dao.ChampionCrossCompetitorDao;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossCompetitor;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossPlayer;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossRobot;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossSystem;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.crossservice.domain.CrossServerGroup;
import com.ayjs.mxzg.cross.module.crossservice.service.CrossServerGroupService;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadder;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadderRobot;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadderRole;
import com.ayjs.mxzg.cross.module.ladder.service.CrossLadderRobotService;
import com.ayjs.mxzg.cross.module.ladder.service.CrossLadderRoleService;
import com.ayjs.mxzg.cross.module.ladder.service.CrossLadderService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionRanker;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.CSChampionRanker.CSChampionRankerBuilder;
import com.ayjs.mxzg.message.module.ladder.message.CrossLadderRank;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.module.champion.ChampionTemplate;

import cn.hutool.core.collection.CollectionUtil;
import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Service
public class ChampionCrossCompetitorService {

	@Autowired
	private ChampionCrossCompetitorDao championCrossCompetitorDao;
	@Autowired
	private BattleTemplate battleTemplate;
	@Autowired
	private CrossServerGroupService crossServerGroupService;
	@Autowired
	private CrossLadderService crossLadderService;
	@Autowired
	private CrossLadderRoleService crossLadderRoleService;
	@Autowired
	private CrossRoleService crossRoleService;
	@Autowired
	private CrossLadderRobotService crossLadderRobotService;
	@Autowired
	private ServerLadderRobotSysCache serverLadderRobotSysCache;
	@Autowired
	private ChampionCrossRobotService championRobotService;
	@Autowired
	private ChampionCrossPlayerService championPlayerService;
	@Autowired
	private ChampionCrossPointSysCache championCrossPointSysCache;
	
	/**
	 * 排行榜<跨服分组ID，<数据>>
	 */
	private Map<Integer, List<ChampionCrossCompetitor>> crossTopList = new ConcurrentHashMap<>();
	
	/**
	 * 本届冠军赛的参赛玩家<跨服分组ID，<玩家或机器人ID，数据>>
	 */
	private final Map<Integer, ConcurrentMap<Long, ChampionCrossCompetitor>> crossCompetitorMap = new ConcurrentHashMap<>();

	public List<ChampionCrossCompetitor> getByRound(int round) {
		return championCrossCompetitorDao.list("round", round);
	}

	public void update(ChampionCrossCompetitor championCompetitor) {
		championCrossCompetitorDao.update(championCompetitor);
	}

	public void updateList(List<ChampionCrossCompetitor> list) {
		championCrossCompetitorDao.update(list);
	}

	public void insertList(List<ChampionCrossCompetitor> list) {
		championCrossCompetitorDao.add(list);
	}
	
	/**
	 * 服务器启动时加载参赛者处理，在ChampionCrossService中执行
	 * @param championRound
	 */
	public List<ChampionCrossCompetitor> loadOnServerStart(int championRound) {
		List<ChampionCrossCompetitor> competitors = this.getByRound(championRound);
		try {
			if (CollectionUtil.isEmpty(competitors)) {
				competitors = this.getByRound(championRound - 1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		for(ChampionCrossCompetitor competitor : competitors) {
			ConcurrentMap<Long, ChampionCrossCompetitor> competitorMap = crossCompetitorMap.get(competitor.getCrossGroup());
			if(competitorMap == null) {
				competitorMap = new ConcurrentHashMap<>();
				crossCompetitorMap.put(competitor.getCrossGroup(), competitorMap);
			}
			competitorMap.put(competitor.getRid(), competitor);
		}
		this.sortCompetitor();
		return competitors;
	}
	
	public void initCompetitor(ChampionCrossSystem championSystem) {
		Map<Integer, List<ChampionCrossCompetitor>> groupMap = new HashMap<>();
		
		//vvvvvvvvvvvvvvvv测试代码vvvvvvvvvvvvvvvv
//		for(int groupId = 1; groupId <= 2; groupId++) {
//			Map<Integer, CrossLadderRank> rankMap = new HashMap<>();
//			for(int j = 1; j <= 256; j++) {
//				CrossLadderData ladderData = new CrossLadderData();
//				ladderData.setReallyPlayer(false);
//				ladderData.setRank(j);
//				ladderData.setRid(j);
//				ladderData.setSid(1003);
//				CrossLadderRank ladderRank = crossLadderService.toCrossLadderRank(ladderData.getRid(), ladderData);
//				rankMap.put(j, ladderRank);
//			}
//			List<ChampionCrossCompetitor> competitors = initCompetitor(championSystem, groupId, rankMap);
//			groupMap.put(groupId, competitors);
//		}
		//^^^^^^^^^^^^^^^^测试代码^^^^^^^^^^^^^^^^
		
		CrossServerGroup crossServerGroup = crossServerGroupService.getCrossServerGroup();
		for (CrossGroup crossGroup : crossServerGroup.getGroups().values()) {
			CrossLadder crossLadder = crossLadderService.getCrossLadder(crossGroup.getGroupId());
			if(crossLadder == null) {
				continue;
			}
			Map<Integer, CrossLadderRank> rankMap = crossLadderService.rankMapAll(crossLadder);
			List<ChampionCrossCompetitor> competitors = initCompetitor(championSystem, crossGroup.getGroupId(),
					rankMap);
			groupMap.put(crossGroup.getGroupId(), competitors);
		}
		//将竞赛者按跨服分组添加到缓存
		for(Entry<Integer, List<ChampionCrossCompetitor>> entry : groupMap.entrySet()) {
			int crossGroupId = entry.getKey();
			ConcurrentMap<Long, ChampionCrossCompetitor> map = crossCompetitorMap.get(crossGroupId);
			if(map == null) {
				map = new ConcurrentHashMap<>();
				crossCompetitorMap.put(crossGroupId, map);
			}
			for(ChampionCrossCompetitor competitor : entry.getValue()) {
				map.put(competitor.getRid(), competitor);
			}
			log.info("跨服冠军赛分组{}入选人数{}", crossGroupId, map.size());
		}
	}

	private List<ChampionCrossCompetitor> initCompetitor(ChampionCrossSystem championSystem, int crossGroup,
			Map<Integer, CrossLadderRank> rankMap) {
		List<ChampionCrossCompetitor> competitors = new ArrayList<>();

		for (int i = 1; i <= ChampionConst.TRIALS_CROSS_PLAYER; i++) {
			CrossLadderRank ladderPlayer = rankMap.get(i);
			if (ladderPlayer == null) {
				continue;
			}
			if (ladderPlayer.isReallyPlayer()) {
				log.info("本届跨服冠军赛入围玩家{}-{}，天梯排名{}", ladderPlayer.getRankId(), ladderPlayer.getRoleName(),
						ladderPlayer.getRank());

				competitors.add(createCompetitor(ladderPlayer.getRankId(), crossGroup, i, championSystem));
			} else {
				log.info("本届跨服冠军赛入围机器人{}-{}，天梯排名{}", ladderPlayer.getRankId(), ladderPlayer.getRoleName(),
						ladderPlayer.getRank());

				competitors.add(createRobotCompetitor(ladderPlayer.getRankId(), crossGroup, i, championSystem));
			}
		}
		// 初始化选拔赛分组
		ChampionTemplate.initTrials(competitors);
		// 插入数据
		insertList(competitors);
		return competitors;
	}

	/**
	 * 创建参赛者数据
	 * 
	 * @param playerData
	 * @param championSystem
	 * @return
	 */
	private ChampionCrossCompetitor createCompetitor(long rid, int crossGroup, int rank, ChampionCrossSystem championSystem) {
		CrossRole role = crossRoleService.getNotThrow(rid);
		if (role == null) {
			return null;
		}
		CrossLadderRole ladderRole = crossLadderRoleService.getLadderRole(rid);

		ChampionCrossCompetitor competitor = new ChampionCrossCompetitor();
		competitor.setRid(ladderRole.getRid());
		competitor.setName(role.getNick());

		//初始积分
		CChampionCrossPoint crossPoint = championCrossPointSysCache.getOrThrow(rank);
		competitor.setOriPoint(crossPoint.getInitial_point());
		competitor.setPoint(crossPoint.getInitial_point());

		competitor.setFighting(ladderRole.getFighting());
		competitor.setBattlerVo(ladderRole.getBattlerVo());
		competitor.setRound(championSystem.getRound());
		competitor.setLevel(role.getLevel());
		competitor.setHeadId(role.getHeadId());
		competitor.setBorderId(role.getBorderId());
		competitor.setServerId(role.getServerId());
		competitor.setRobot(0);
		competitor.setCrossGroup(crossGroup);
		return competitor;
	}

	/**
	 * 创建机器人数据
	 * 
	 * @param robotRole
	 * @param championSystem
	 * @return
	 */
	private ChampionCrossCompetitor createRobotCompetitor(long robotId, int crossGroup, int rank,
			ChampionCrossSystem championSystem) {
		CrossLadderRobot robot = crossLadderRobotService.getRobot(robotId);

		// 机器人战斗数据
		List<CServerLadderRobot> teamList = serverLadderRobotSysCache.getTeam((int) robotId);
		BattlerDo battlerDo = battleTemplate.queryBattler(teamList, robot.getNick(), Faction.DEFENDER, UnitType.MOSTER);
		BattlerVo battlerVo = battlerDo.toBattlerVo();
		battlerVo.setPlayerId(robotId);
		// 机器人战力
		int fighting = battleTemplate.computeMonsterStrength(teamList);

		ChampionCrossCompetitor competitor = new ChampionCrossCompetitor();
		competitor.setRid(robotId);
		competitor.setName(robot.getNick());

		//初始积分
		CChampionCrossPoint crossPoint = championCrossPointSysCache.getOrThrow(rank);
		competitor.setOriPoint(crossPoint.getInitial_point());
		competitor.setPoint(crossPoint.getInitial_point());

		competitor.setFighting(fighting);
		competitor.setBattlerVo(battlerVo);
		competitor.setRound(championSystem.getRound());
		competitor.setRobot(1);
		competitor.setLevel(robot.getLevel());
		competitor.setHeadId(robot.getHeadId());
		competitor.setBorderId(robot.getBorderId());
		competitor.setServerId(0);
		competitor.setCrossGroup(crossGroup);
		return competitor;
	}
	
	/**
	 * 排序比赛者
	 */
	public void sortCompetitor() {
		for(Entry<Integer, ConcurrentMap<Long, ChampionCrossCompetitor>> entry : this.crossCompetitorMap.entrySet()) {
			List<ChampionCrossCompetitor> allCompetitor = new ArrayList<>(entry.getValue().values());
			Collections.sort(allCompetitor, ChampionTemplate.COMPETITOR_SORTER);
			for(int i = 0; i < allCompetitor.size(); i++) {
				ChampionCrossCompetitor competitor = allCompetitor.get(i);
				competitor.setRank(i + 1);
			}
			this.updateList(allCompetitor);
			this.crossTopList.put(entry.getKey(), allCompetitor);
		}
	}

	public List<ChampionCrossCompetitor> getTopList(int crossGroupId) {
		return crossTopList.get(crossGroupId);
	}

	public ConcurrentMap<Long, ChampionCrossCompetitor> getCrossGroupCompetitor(int crossGroup) {
		return crossCompetitorMap.get(crossGroup);
	}
	
	public Map<Integer, ConcurrentMap<Long, ChampionCrossCompetitor>> getCompetitorMap() {
		return crossCompetitorMap;
	}
	
	public Set<Integer> getCrossGroups() {
		return crossCompetitorMap.keySet();
	}
	
	public ChampionCrossCompetitor getCompetitor(long rid, int crossGroupId) {
		ConcurrentMap<Long, ChampionCrossCompetitor> competitorMap = crossCompetitorMap.get(crossGroupId);
		if(competitorMap == null) {
			return null;
		}
		return competitorMap.get(rid);
	}
	
	public void restart() {
		this.crossCompetitorMap.clear();
		this.crossTopList.clear();
	}
	
	/**
	 * 获取玩家当前的排名
	 * @param rid
	 * @return
	 */
	public int getRoleRank(long rid) {
		CrossRole role = crossRoleService.getNotThrow(rid);
		if(role == null) {
			return 0;
		}
		int crossGroupId = crossServerGroupService.getGroupId(role.getServerId());
		ConcurrentMap<Long, ChampionCrossCompetitor> competitorMap = crossCompetitorMap.get(crossGroupId);
		if(competitorMap == null) {
			return 0;
		}
		ChampionCrossCompetitor competitor = competitorMap.get(rid);
		if(competitor == null) {
			return 0;
		}
		return competitor.getRank();
	}
	
	public CSChampionRanker serialChampionRank(ChampionCrossCompetitor competitor) {
		CSChampionRankerBuilder builder = CSChampionRanker.builder();
		builder.rid(competitor.getRid());
		builder.robot(competitor.getRobot());
		if(competitor.getRobot() == 1) {
			ChampionCrossRobot robot = championRobotService.getRobot(competitor.getRid());
			builder.like(robot.getLike());
		} else {
			ChampionCrossPlayer championPlayer = championPlayerService.getPlayer(competitor.getRid());
			builder.like(championPlayer.getLike());
			CrossRole role = crossRoleService.getNotThrow(competitor.getRid());
			if(role != null) {
				builder.serverId(role.getServerId());
			}
		}
		builder.name(competitor.getName());
		builder.rank(competitor.getRank());
		builder.level(competitor.getLevel());
		builder.headId(competitor.getHeadId());
		builder.borderId(competitor.getBorderId());
		builder.point(competitor.getPoint());
		builder.fighting(competitor.getFighting());
		return builder.build();
	}
}
