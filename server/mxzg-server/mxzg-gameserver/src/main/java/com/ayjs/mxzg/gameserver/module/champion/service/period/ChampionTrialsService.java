/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.champion.service.period;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.config.excel.constant.ChampionConst;
import com.ayjs.mxzg.config.excel.constant.ChampionPeriod;
import com.ayjs.mxzg.config.excel.entity.CChampionRound;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionBattle;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionCompetitor;
import com.ayjs.mxzg.gameserver.module.champion.domain.ChampionSystem;
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
	
	private Map<Integer, ChampionTrialsGroup> groupMap = new ConcurrentHashMap<>();
	
	@Override
	protected ChampionPeriod getPeriod() {
		return ChampionPeriod.TRIALS;
	}

	@Override
	protected boolean isPeriodEnd(ChampionSystem championSystem) {
		return championSystem.getBattleRound() > championRoundSysCache.getMaxTrialsRound();
	}

	@Override
	protected void settlePeriod(ChampionSystem championSystem) {
		//选拔赛所有轮的比赛都结束后，进入淘汰赛
		championSystem.setPeriod(ChampionPeriod.KNOCKOUT.getValue());
		championSystem.setBattleRound(ChampionConst.GROUP_COUNT * ChampionConst.GROUP_SIZE);
		
		//初始化淘汰赛分组
		championKnockoutService.initMatchGroup();
		
		log.info("冠军赛进入淘汰赛阶段，下一阶段执行时间{}", championSystem.nextStageTime());
	}

	@Override
	protected CChampionRound getRoundConfig(int battleRound) {
		return championRoundSysCache.getTrialsRound(battleRound);
	}

	@Override
	protected void handleBattleMatch(ChampionSystem championSystem) {
		log.info("冠军赛选拔赛正在生成战斗数据");
		List<ChampionBattle> battleList = new ArrayList<>();
		
		if(championSystem.getBattleRound() <= ChampionConst.TRIALS_WIN_ROUND) {
			for(ChampionTrialsGroup group : groupMap.values()) {
				for(int i = 0; i < group.getBefore().size(); i++) {
					IChampionCompetitor atk = group.getBefore().get(i);
					IChampionCompetitor def = group.getAfter().get((championSystem.getBattleRound() + i) % group.getAfter().size());
					
					ChampionBattle battle = championBattleService.createTrialsBattle(championSystem, atk, def);
					battleList.add(battle);
				}
			}
		} else {
			//已经匹配过战斗的分组ID
			Set<Integer> groupSet = new HashSet<>();
			
			for(ChampionTrialsGroup atkGroup : groupMap.values()) {
				if(groupSet.contains(atkGroup.getId())) {
					continue;
				}
				ChampionTrialsGroup defGroup = groupMap.get(atkGroup.getChaosGroup());
				groupSet.add(atkGroup.getId());
				groupSet.add(defGroup.getId());
				
				for(int i = 0; i < atkGroup.getChaos().size(); i++) {
					IChampionCompetitor atk = atkGroup.getChaos().get(i);
					IChampionCompetitor def = defGroup.getChaos().get((championSystem.getBattleRound() + i) % defGroup.getChaos().size());
					
					ChampionBattle battle = championBattleService.createTrialsBattle(championSystem, atk, def);
					battleList.add(battle);
				}
			}
		}
		//插入匹配好的战斗记录
		championBattleService.insertBattles(battleList);
		championService.setRunningBattle(battleList);
		championService.addAllBattling(battleList);
		log.info("冠军赛选拔赛生成战斗" + battleList.size() + "场");
	}

	/**
	 * 初始化选拔赛分组
	 * @param competitors
	 */
	public void initMatchGroup() {
		List<ChampionCompetitor> competitors = new ArrayList<>(championService.getCompetitorMap().values());
		groupMap.clear();
		groupMap.putAll(ChampionTrialsGroup.initTrialsGroups(competitors));
	}

	@Override
	protected void setNextBattleRound(ChampionSystem championSystem) {
		//战斗轮数加1
		championSystem.setBattleRound(championSystem.getBattleRound() + 1);
	}
}
