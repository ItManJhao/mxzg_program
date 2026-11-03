/**
 * 
 */
package com.ayjs.mxzg.cross.module.champion.service.period;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.config.excel.constant.ChampionConst;
import com.ayjs.mxzg.config.excel.constant.ChampionPeriod;
import com.ayjs.mxzg.config.excel.entity.CChampionRound;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossBattle;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossCompetitor;
import com.ayjs.mxzg.cross.module.champion.domain.ChampionCrossSystem;
import com.ayjs.mxzg.module.champion.ChampionTrialsGroup;
import com.ayjs.mxzg.module.champion.IChampionCompetitor;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 * 选拔赛逻辑
 */
@Slf4j
@Service
public class ChampionTrialsService extends ChampionPeriodService {
	
	@Autowired
	private ChampionKnockoutService championKnockoutService;
	//<跨服分组ID，<战斗组ID，战斗组数据>>
	private Map<Integer, ConcurrentMap<Integer, ChampionTrialsGroup>> crossGroupMap = new ConcurrentHashMap<>();
	
	@Override
	protected ChampionPeriod getPeriod() {
		return ChampionPeriod.TRIALS;
	}

	@Override
	protected boolean isPeriodEnd(ChampionCrossSystem championSystem) {
		return championSystem.getBattleRound() > championRoundSysCache.getMaxTrialsRound();
	}

	@Override
	protected void settlePeriod(ChampionCrossSystem championSystem) {
		//选拔赛所有轮的比赛都结束后，进入淘汰赛
		championSystem.setPeriod(ChampionPeriod.KNOCKOUT.getValue());
		championSystem.setBattleRound(ChampionConst.CROSS_GROUP_COUNT * ChampionConst.GROUP_SIZE);
		
		//初始化淘汰赛分组
		championKnockoutService.initMatchGroup();
		
		log.info("跨服冠军赛进入淘汰赛阶段，下一阶段执行时间{}", championSystem.nextStageTime());
	}

	@Override
	protected CChampionRound getRoundConfig(int battleRound) {
		return championRoundSysCache.getCrossTrialsRound(battleRound);
	}

	@Override
	protected void handleBattleMatch(ChampionCrossSystem championSystem) {
		List<ChampionCrossBattle> battleList = new ArrayList<>();
		
		for(ConcurrentMap<Integer, ChampionTrialsGroup> trialsMap : crossGroupMap.values()) {
			if(championSystem.getBattleRound() <= ChampionConst.TRIALS_WIN_ROUND) {
				for(ChampionTrialsGroup group : trialsMap.values()) {
					for(int i = 0; i < group.getBefore().size(); i++) {
						IChampionCompetitor atk = group.getBefore().get(i);
						IChampionCompetitor def = group.getAfter().get((championSystem.getBattleRound() + i) % group.getAfter().size());
						
						ChampionCrossBattle battle = championBattleService.createTrialsBattle(championSystem, atk, def);
						battleList.add(battle);
					}
				}
			} else {
				//已经匹配过战斗的分组ID
				Set<Integer> groupSet = new HashSet<>();
				
				for(ChampionTrialsGroup atkGroup : trialsMap.values()) {
					if(groupSet.contains(atkGroup.getId())) {
						continue;
					}
					ChampionTrialsGroup defGroup = trialsMap.get(atkGroup.getChaosGroup());
					groupSet.add(atkGroup.getId());
					groupSet.add(defGroup.getId());
					
					for(int i = 0; i < atkGroup.getChaos().size(); i++) {
						IChampionCompetitor atk = atkGroup.getChaos().get(i);
						IChampionCompetitor def = defGroup.getChaos().get((championSystem.getBattleRound() + i) % defGroup.getChaos().size());
						
						ChampionCrossBattle battle = championBattleService.createTrialsBattle(championSystem, atk, def);
						battleList.add(battle);
					}
				}
			}
		}
		
		//插入匹配好的战斗记录
		championBattleService.setRunningBattle(battleList);
	}

	/**
	 * 初始化选拔赛分组
	 * @param competitors
	 */
	public void initMatchGroup() {
		Map<Integer, ConcurrentMap<Long, ChampionCrossCompetitor>> competitors = championCompetitorService.getCompetitorMap();
		crossGroupMap.clear();
		
		for(Entry<Integer, ConcurrentMap<Long, ChampionCrossCompetitor>> entry : competitors.entrySet()) {
			//跨服分组ID
			int crossGroupId = entry.getKey();
			ConcurrentMap<Integer, ChampionTrialsGroup> groupMap = ChampionTrialsGroup.initTrialsGroups(entry.getValue().values());
			crossGroupMap.put(crossGroupId, groupMap);
		}
	}

	@Override
	protected void setNextBattleRound(ChampionCrossSystem championSystem) {
		//战斗轮数加1
		championSystem.setBattleRound(championSystem.getBattleRound() + 1);
	}
}
