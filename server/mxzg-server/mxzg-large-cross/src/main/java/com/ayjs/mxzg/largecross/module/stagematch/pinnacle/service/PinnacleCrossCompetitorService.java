/**
 * 
 */
package com.ayjs.mxzg.largecross.module.stagematch.pinnacle.service;

import cn.hutool.core.collection.CollectionUtil;
import com.alibaba.fastjson.JSON;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.config.excel.cache.ServerLadderRobotSysCache;
import com.ayjs.mxzg.config.excel.cache.TopMatchSecondPointSysCache;
import com.ayjs.mxzg.config.excel.constant.PinnacleConst;
import com.ayjs.mxzg.config.excel.constant.PreliminariesConst;
import com.ayjs.mxzg.config.excel.entity.CChampionCrossPoint;
import com.ayjs.mxzg.config.excel.entity.CServerLadderRobot;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondPoint;
import com.ayjs.mxzg.largecross.module.robot.domain.LargeCrossRobot;
import com.ayjs.mxzg.largecross.module.robot.service.LargeCrossRobotService;
import com.ayjs.mxzg.largecross.module.stagematch.battle.dao.OpponentDao;
import com.ayjs.mxzg.largecross.module.stagematch.battle.domain.Opponent;
import com.ayjs.mxzg.largecross.module.stagematch.battle.manager.OpponentGroup;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.dao.PinnacleCrossCompetitorDao;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossCompetitor;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossPlayer;
import com.ayjs.mxzg.largecross.module.stagematch.pinnacle.domain.PinnacleCrossSystem;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.dao.PreliminariesLadderDao;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.domain.PreliminariesLadder;
import com.ayjs.mxzg.largecross.module.stagematch.preliminaries.service.PreliminariesService;
import com.ayjs.mxzg.largecross.servergroup.domain.CrossServerGroup;
import com.ayjs.mxzg.largecross.servergroup.service.ServerGroupService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.stagematch.dto.RankDto;
import com.ayjs.mxzg.message.module.stagematch.pinnacle.PinnacleMessage.CSPinnacleRanker;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.module.pinnacle.PinnacleTemplate;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;


@Slf4j
@Service
public class PinnacleCrossCompetitorService {

	@Autowired
	private BattleTemplate battleTemplate;
	@Autowired
	private PinnacleCrossCompetitorDao pinnacleCrossCompetitorDao;
	@Autowired
	private ServerGroupService serverGroupService;
	@Autowired
	private OpponentDao opponentDao;
	@Autowired
	private PreliminariesLadderDao preliminariesLadderDao;
	@Autowired
	private PreliminariesService crossLadderService;
	@Autowired
	private PinnacleCrossPlayerService pinnacleCrossPlayerService;
	@Autowired
	private LargeCrossRobotService largeCrossRobotService;
	@Autowired
	private TopMatchSecondPointSysCache topMatchSecondPointSysCache;
	@Autowired
	private ServerLadderRobotSysCache serverLadderRobotSysCache;
	@Autowired
	private PreliminariesConst preliminariesConst;

	/**
	 * 排行榜<跨服分组ID，<数据>>
	 */
	private Map<Integer, List<PinnacleCrossCompetitor>> crossTopList = new ConcurrentHashMap<>();

	/**
	 * 本届冠军赛的参赛玩家<跨服分组ID，<玩家或机器人ID，数据>>
	 */
	private final Map<Integer, ConcurrentMap<Long, PinnacleCrossCompetitor>> crossCompetitorMap = new ConcurrentHashMap<>();

	public List<PinnacleCrossCompetitor> getByRound(int round) {
		return pinnacleCrossCompetitorDao.list("round", round);
	}

	public void update(PinnacleCrossCompetitor championCompetitor) {
		pinnacleCrossCompetitorDao.update(championCompetitor);
	}

	public void updateList(List<PinnacleCrossCompetitor> list) {
		pinnacleCrossCompetitorDao.update(list);
	}

	public void insertList(List<PinnacleCrossCompetitor> list) {
		pinnacleCrossCompetitorDao.add(list);
	}

	/**
	 * 服务器启动时加载参赛者处理，在PinnacleCrossService中执行
	 * @param championRound
	 */
	public List<PinnacleCrossCompetitor> loadOnServerStart(int championRound) {
		List<PinnacleCrossCompetitor> competitors = this.getByRound(championRound);
		try {
			if (CollectionUtil.isEmpty(competitors)) {
				competitors = this.getByRound(championRound - 1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		for(PinnacleCrossCompetitor competitor : competitors) {
			ConcurrentMap<Long, PinnacleCrossCompetitor> competitorMap = crossCompetitorMap.get(competitor.getCrossGroup());
			if(competitorMap == null) {
				competitorMap = new ConcurrentHashMap<>();
				crossCompetitorMap.put(competitor.getCrossGroup(), competitorMap);
			}
			competitorMap.put(competitor.getRid(), competitor);
		}
		this.sortCompetitor();
		return competitors;
	}

	public void initCompetitor(PinnacleCrossSystem championSystem) {
		Map<Integer, List<PinnacleCrossCompetitor>> groupMap = new HashMap<>();

		CrossServerGroup crossServerGroup = serverGroupService.getCrossServerGroup();
		for (CrossGroup crossGroup : crossServerGroup.getGroups().values()) {
			OpponentGroup crossLadder = crossLadderService.getCrossLadder(crossGroup.getGroupId());
			if(crossLadder == null || CollectionUtils.isEmpty(crossLadder.allRankMap())) {
				continue;
			}
			Map<Integer, RankDto> rankMap = crossLadder.allRankMap();
			List<PinnacleCrossCompetitor> competitors = initCompetitor(championSystem, crossGroup.getGroupId(),	rankMap);
			if(competitors.size() == PinnacleConst.TRIALS_CROSS_PLAYER){
				groupMap.put(crossGroup.getGroupId(), competitors);
			}
		}
		//将竞赛者按跨服分组添加到缓存
		for(Entry<Integer, List<PinnacleCrossCompetitor>> entry : groupMap.entrySet()) {
			int crossGroupId = entry.getKey();
			ConcurrentMap<Long, PinnacleCrossCompetitor> map = crossCompetitorMap.get(crossGroupId);
			if(map == null) {
				map = new ConcurrentHashMap<>();
				crossCompetitorMap.put(crossGroupId, map);
			}
			for(PinnacleCrossCompetitor competitor : entry.getValue()) {
				map.put(competitor.getRid(), competitor);
			}
			log.info("巅峰赛分组{}入选人数{}", crossGroupId, map.size());
		}
	}

	private List<PinnacleCrossCompetitor> initCompetitor(PinnacleCrossSystem championSystem, int crossGroup, Map<Integer, RankDto> rankMap) {
		List<PinnacleCrossCompetitor> competitors = new ArrayList<>();
		List<LargeCrossRobot> robots = largeCrossRobotService.getAllRobot();
		int robotIndex = 0;
		int defaultRank = 0;
		for (int i = 1; competitors.size() < PinnacleConst.TRIALS_CROSS_PLAYER; i++) {
			if(i <= rankMap.size()){
				RankDto ladderPlayer = rankMap.get(i);
				if (ladderPlayer == null) {
					defaultRank++;
					continue;
				}
				int rank = i - defaultRank;
				log.info("本届巅峰赛入围玩家{}-{}，天梯排名{}", ladderPlayer.getRid(), ladderPlayer.getName(), rank);
				competitors.add(createCompetitor(ladderPlayer.getRid(), crossGroup, rank, championSystem));
			} else {
				if(robotIndex < robots.size()){
					LargeCrossRobot robot = robots.get(robotIndex);
					robotIndex++;
					int rank = i - defaultRank;
					log.info("本届巅峰赛添加机器人{}-{}，天梯排名{}", robot.getRid(), robot.getNick(), rank);
					competitors.add(createRobotCompetitor(robot.getRid(), crossGroup, rank, championSystem));
				} else {
					log.info("本届巅峰赛玩家数量{}不足，机器人数量不足{}", rankMap.size(), robots.size());
					break;
				}
			}
		}
		if(competitors.size() == PinnacleConst.TRIALS_CROSS_PLAYER){
			// 初始化选拔赛分组
			PinnacleTemplate.initTrials(competitors);
			// 插入数据
			insertList(competitors);
		} else {
			log.info("巅峰赛跨服分组{}参赛玩家不足{}", crossGroup, competitors.size());
		}

		return competitors;
	}

	/**
	 * 创建参赛者数据
	 *
	 * @param championSystem
	 * @return
	 */
	private PinnacleCrossCompetitor createCompetitor(long rid, int crossGroup, int rank, PinnacleCrossSystem championSystem) {
		Opponent role = opponentDao.get(rid);
		PreliminariesLadder ladder = preliminariesLadderDao.get(rid);
		if(role == null || ladder == null){
			return null;
		}

		PinnacleCrossCompetitor competitor = new PinnacleCrossCompetitor();
		competitor.setRid(role.getRid());
		competitor.setName(role.getName());

		//初始积分
		CTopMatchSecondPoint crossPoint = topMatchSecondPointSysCache.getOrThrow(rank);
		competitor.setOriPoint(crossPoint.getInitial_point());
		competitor.setPoint(crossPoint.getInitial_point());

		competitor.setFighting(role.getFighting());
		String battleVo = StringUtils.isBlank(ladder.getBattlerVo()) ? role.getBattlerVo() : ladder.getBattlerVo();
		competitor.setBattlerVo(JSON.parseObject(battleVo, BattlerVo.class));
		competitor.setRound(championSystem.getRound());
		competitor.setLevel(role.getLevel());
		competitor.setHeadId(role.getHeadId());
		competitor.setBorderId(role.getBorderId());
		competitor.setServerId(role.getServerId());
		competitor.setRobot(0);
		competitor.setCrossGroup(crossGroup);
		competitor.setImageId(role.getImage_id());
		return competitor;
	}

	/**
	 * 创建机器人
	 * @param robotId
	 * @param crossGroup
	 * @param rank
	 * @param championSystem
	 * @return
	 */
	private PinnacleCrossCompetitor createRobotCompetitor(long robotId, int crossGroup, int rank,
			PinnacleCrossSystem championSystem) {
		LargeCrossRobot robot = largeCrossRobotService.getRobot(robotId);

		// 机器人战斗数据
		List<CServerLadderRobot> teamList = serverLadderRobotSysCache.getTeam((int) robotId);
		BattlerDo battlerDo = battleTemplate.queryBattler(teamList, robot.getNick(), Faction.DEFENDER, UnitType.MOSTER);
		BattlerVo battlerVo = battlerDo.toBattlerVo();
		battlerVo.setPlayerId(robotId);
		// 机器人战力
		int fighting = battleTemplate.computeMonsterStrength(teamList);

		PinnacleCrossCompetitor competitor = new PinnacleCrossCompetitor();
		competitor.setRid(robotId);
		competitor.setName(robot.getNick());

		//初始积分
		CTopMatchSecondPoint crossPoint = topMatchSecondPointSysCache.getOrThrow(rank);
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
		for(Entry<Integer, ConcurrentMap<Long, PinnacleCrossCompetitor>> entry : this.crossCompetitorMap.entrySet()) {
			List<PinnacleCrossCompetitor> allCompetitor = new ArrayList<>(entry.getValue().values());
			Collections.sort(allCompetitor, PinnacleTemplate.COMPETITOR_SORTER);
			for(int i = 0; i < allCompetitor.size(); i++) {
				PinnacleCrossCompetitor competitor = allCompetitor.get(i);
				competitor.setRank(i + 1);
			}
			this.updateList(allCompetitor);
			this.crossTopList.put(entry.getKey(), allCompetitor);
		}
	}

	public List<PinnacleCrossCompetitor> getTopList(int crossGroupId) {
		return crossTopList.get(crossGroupId);
	}

	public ConcurrentMap<Long, PinnacleCrossCompetitor> getCrossGroupCompetitor(int crossGroup) {
		return crossCompetitorMap.get(crossGroup);
	}

	public Map<Integer, ConcurrentMap<Long, PinnacleCrossCompetitor>> getCompetitorMap() {
		return crossCompetitorMap;
	}

	public Set<Integer> getCrossGroups() {
		return crossCompetitorMap.keySet();
	}

	public PinnacleCrossCompetitor getCompetitor(long rid, int crossGroupId) {
		ConcurrentMap<Long, PinnacleCrossCompetitor> competitorMap = crossCompetitorMap.get(crossGroupId);
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
		Opponent role = opponentDao.get(rid);
		if(role == null) {
			return 0;
		}
		int crossGroupId = serverGroupService.getGroupId(role.getServerId());
		ConcurrentMap<Long, PinnacleCrossCompetitor> competitorMap = crossCompetitorMap.get(crossGroupId);
		if(competitorMap == null) {
			return 0;
		}
		PinnacleCrossCompetitor competitor = competitorMap.get(rid);
		if(competitor == null) {
			return 0;
		}
		return competitor.getRank();
	}

	public CSPinnacleRanker serialPinnacleRank(PinnacleCrossCompetitor competitor) {
		CSPinnacleRanker.CSPinnacleRankerBuilder builder = CSPinnacleRanker.builder();
		builder.rid(competitor.getRid());
		builder.robot(competitor.getRobot());

		PinnacleCrossPlayer championPlayer = pinnacleCrossPlayerService.getPlayer(competitor.getRid());
		builder.like(championPlayer.getLike());
		if(competitor.getRobot() == 1){
			LargeCrossRobot robot = largeCrossRobotService.getRobot(competitor.getRid());
			builder.level(robot.getLevel());
			builder.headId(robot.getHeadId());
			builder.borderId(robot.getBorderId());
			builder.imageId(robot.getImageId());
			builder.stageId(preliminariesConst.PRELIMINARY_QUALIFICATION_STAGE_ID);
		} else {
			Opponent role = opponentDao.get(competitor.getRid());
			builder.level(role.getLevel());
			builder.headId(role.getHeadId());
			builder.borderId(role.getBorderId());
			builder.imageId(role.getImage_id());
			builder.stageId(role.getStageId());
		}

		builder.serverId(competitor.getServerId());
		builder.name(competitor.getName());
		builder.rank(competitor.getRank());
		builder.point(competitor.getPoint());
		builder.fighting(competitor.getFighting());
		return builder.build();
	}
}
