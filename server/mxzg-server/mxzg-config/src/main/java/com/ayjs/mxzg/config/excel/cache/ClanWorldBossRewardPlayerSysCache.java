/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.Comparator;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CClanWorldBossRewardPlayer;

/**
 * @author YY
 * 玩家排名奖励
 */
@Component
public class ClanWorldBossRewardPlayerSysCache extends BaseExcelCache<CClanWorldBossRewardPlayer> {

	private Map<Integer, List<CClanWorldBossRewardPlayer>> typeMap;
	
	@Override
	public String getFileName() {
		return "clanworldbossrewardplayer";
	}

	@Override
	protected void loadAfterReady() {
		this.typeMap = this.fillListMap(CClanWorldBossRewardPlayer::getReward_rank_type);
		for(List<CClanWorldBossRewardPlayer> list : this.typeMap.values()) {
			list.sort(Comparator.comparingInt(CClanWorldBossRewardPlayer::getRank_low));
		}
	}
	
	public CClanWorldBossRewardPlayer getByTypeRank(int type, int rank) {
		List<CClanWorldBossRewardPlayer> list = typeMap.get(type);
		if(list == null) {
			return null;
		}
		for(CClanWorldBossRewardPlayer reward : list) {
			if(reward.getRank_low() <= rank && rank <= reward.getRank_up()) {
				return reward;
			}
		}
		return null;
	}
}
