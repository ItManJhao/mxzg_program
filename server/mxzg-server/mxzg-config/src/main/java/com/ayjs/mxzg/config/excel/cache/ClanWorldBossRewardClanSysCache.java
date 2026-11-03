/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.Comparator;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CClanWorldBossRewardClan;

/**
 * @author YY
 * 公会排名奖励
 */
@Component
public class ClanWorldBossRewardClanSysCache extends BaseExcelCache<CClanWorldBossRewardClan> {

	private Map<Integer, List<CClanWorldBossRewardClan>> typeMap;
	
	@Override
	public String getFileName() {
		return "clanworldbossrewardclan";
	}

	@Override
	protected void loadAfterReady() {
		this.typeMap = this.fillListMap(CClanWorldBossRewardClan::getReward_rank_type);
		for(List<CClanWorldBossRewardClan> list : this.typeMap.values()) {
			list.sort(Comparator.comparingInt(CClanWorldBossRewardClan::getRank_low));
		}
	}
	
	public CClanWorldBossRewardClan getByTypeRank(int type, int rank) {
		List<CClanWorldBossRewardClan> list = typeMap.get(type);
		if(list == null) {
			return null;
		}
		for(CClanWorldBossRewardClan reward : list) {
			if(reward.getRank_low() <= rank && rank <= reward.getRank_up()) {
				return reward;
			}
		}
		return null;
	}
}
