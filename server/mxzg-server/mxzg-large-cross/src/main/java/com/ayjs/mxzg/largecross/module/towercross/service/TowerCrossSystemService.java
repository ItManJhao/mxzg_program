/**
 * 
 */
package com.ayjs.mxzg.largecross.module.towercross.service;


import java.util.ArrayList;
import java.util.List;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.top.TopN;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.timetower.TimeTowerBaseSysCache;
import com.ayjs.mxzg.largecross.module.towercross.dao.TowerCrossSystemDao;
import com.ayjs.mxzg.largecross.module.towercross.domain.TowerCrossSystem;
import com.ayjs.mxzg.largecross.servergroup.MessageHelper;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.CSTimeTowerReward;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.CSTimeTowerReward.CSTimeTowerRewardBuilder;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ResTimeTowerRewardMessage;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ResTimeTowerRewardMessage.ResTimeTowerRewardMessageBuilder;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Service
public class TowerCrossSystemService {

	@Autowired
	private TowerCrossSystemDao towerCrossSystemDao;
	@Autowired
	private TimeTowerBaseSysCache timeTowerBaseSysCache;
	@Autowired
	private TowerCrossRankService towerCrossRankService;
	@Autowired
	private MessageHelper messageHelper;
	
	public TowerCrossSystem getSystem() {
		List<TowerCrossSystem> systemList = towerCrossSystemDao.listAll();
		TowerCrossSystem system = null;
		if(systemList.isEmpty()) {
			system = new TowerCrossSystem();
			system.setRound(1);
			int weekZero = TimeDateUtil.getSundayZeroInt();
			system.setStartTime(weekZero + timeTowerBaseSysCache.getOpenTime());
			system.setEndTime(weekZero + timeTowerBaseSysCache.getEndTime());
			system.setNextTime(weekZero + TimeDateUtil.ONEWEEKINT + timeTowerBaseSysCache.getOpenTime());
			towerCrossSystemDao.add(system);
		} else {
			system = systemList.get(0);
		}
		return system;
	}
	
	public void update(TowerCrossSystem system) {
		towerCrossSystemDao.update(system);
	}
	
	public void runForThread() {
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		TowerCrossSystem system = this.getSystem();
		if(system.getState() == 0 && nowTime >= system.getEndTime()) {
			//TODO 结算
			system.setState(1);
			this.update(system);
			
			sendTowerReward(system.getRound());
		}
		if(nowTime >= system.getNextTime()) {
			int weekZero = TimeDateUtil.getSundayZeroInt();
			system.setRound(system.getRound() + 1);
			system.setState(0);
			system.setStartTime(weekZero + timeTowerBaseSysCache.getOpenTime());
			system.setEndTime(weekZero + timeTowerBaseSysCache.getEndTime());
			system.setNextTime(weekZero + TimeDateUtil.ONEWEEKINT + timeTowerBaseSysCache.getOpenTime());
			this.update(system);
			log.info("时空魔塔赛季变换");
		}
	}
	
	public void sendTowerReward(int round) {
		log.info("正在发放时空魔塔的第" + round + "赛季奖励");
		for(Entry<Integer, TopN<Long, RankData>> entry : towerCrossRankService.getGroupTopN().entrySet()) {
			int largeGroupId = entry.getKey();
			
			ResTimeTowerRewardMessageBuilder builder = ResTimeTowerRewardMessage.builder();
			builder.round(round);
			
			TopN<Long, RankData> topN = entry.getValue();
			List<RankData> rankList = topN.top(topN.size());
			
			List<CSTimeTowerReward> rewardList = new ArrayList<>();
			for(int i = 0; i < rankList.size(); i++) {
				RankData rankData = rankList.get(i);
				CSTimeTowerRewardBuilder roleBuilder = CSTimeTowerReward.builder();
				roleBuilder.rid(rankData.getRankId());
				roleBuilder.rank(i + 1);
				rewardList.add(roleBuilder.build());
			}
			builder.rewardRank(rewardList);
			messageHelper.pushToGroupMessage(largeGroupId, builder.build());
		}
		log.info("已经发放完毕时空魔塔的第" + round + "赛季奖励");
	}
}
