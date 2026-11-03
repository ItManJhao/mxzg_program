package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigNotFoundException;
import com.ayjs.mxzg.config.excel.entity.CFirstRewardTower;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class FirstRewardTowerSysCache extends BaseExcelCache<CFirstRewardTower> {

	private Map<Integer, CFirstRewardTower> map = new HashMap<>();

	@Override
	public String getFileName() {
		return "firstrewardtower";
	}


	@Override
	protected void loadAfterReady() {
		List<CFirstRewardTower> all = getAll();
		for (CFirstRewardTower cFirstRewardTower : all) {
			map.put(cFirstRewardTower.getChapter(), cFirstRewardTower);
		}
	}

	/**
	 * 根据关卡获取首胜奖励
	 * @param chapterId
	 * @return
	 */
	public CFirstRewardTower getChapterOrThrow(int chapterId){
		CFirstRewardTower cFirstRewardTower = map.get(chapterId);
		if(cFirstRewardTower != null){
			return cFirstRewardTower;
		}
		throw new ConfigNotFoundException(String.format("CFirstRewardTower配置数据不存在chapterId{%s}", chapterId));
	}

}