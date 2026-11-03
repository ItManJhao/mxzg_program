/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CTopMatchSecondRound;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Component
public class TopMatchSecondRoundSysCache extends BaseExcelCache<CTopMatchSecondRound> {
	/**
	 * 跨服配置
	 */
	private Map<Integer, CTopMatchSecondRound> crossRoundMap = new HashMap<>();

	private int firstRound;
	
	@Override
	public String getFileName() {
		return "topmatchsecondround";
	}

	@Override
	protected void loadAfterReady() {
		for (CTopMatchSecondRound cTopMatchSecondRound : getAll()) {
			crossRoundMap.put(cTopMatchSecondRound.getRound(), cTopMatchSecondRound);
		}
		List<CTopMatchSecondRound> rounds = getAll();
		if(!CollectionUtils.isEmpty(rounds)){
			this.firstRound = rounds.get(0).getRound();
		}
	}

	public CTopMatchSecondRound getCrossKnockoutRound(int round) {
		CTopMatchSecondRound cRound = crossRoundMap.get(round);
		ConfigAsserts.notNull(cRound, () -> String.format("CPinnacleRound巅峰赛回合配置数据不存在{%s}", round));
		return cRound;
	}

	/**
	 * 第一回合
	 * @return
	 */
	public int getFirstRound(){
		return this.firstRound;
	}

}
