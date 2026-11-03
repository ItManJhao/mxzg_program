/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.task.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.task.dao.PromotionCycleRewardDao;
import com.ayjs.mxzg.gameserver.module.task.domain.PromotionCycleReward;

/**
 * @author YY
 *
 */
@Service
public class PromotionCycleRewardService {
	@Autowired
	private PromotionCycleRewardDao promotionCycleRewardDao;
	
	public List<PromotionCycleReward> getCycleRewards(long rid) {
		return promotionCycleRewardDao.list("rid", rid);
	}
	
	public Map<Integer, PromotionCycleReward> getPromotionRewards(long rid, PromotionType type) {
		Map<Integer, PromotionCycleReward> map = new HashMap<>();
		for(PromotionCycleReward reward : getCycleRewards(rid)) {
			if(reward.getType() == type.getId()) {
				map.put(reward.getIdx(), reward);
			}
		}
		return map;
	}
	
	public void addCycleReward(PromotionCycleReward cycleReward) {
		promotionCycleRewardDao.add(cycleReward);
	}
	
	public void updateCycleReward(PromotionCycleReward cycleReward) {
		promotionCycleRewardDao.update(cycleReward);
	}
	
	public void deleteCycleReward(List<PromotionCycleReward> list) {
		promotionCycleRewardDao.remove(list);
	}
	
}
