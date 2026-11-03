package com.ayjs.mxzg.config.excel.cache;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.entity.CTavern;

@Component
public class TavernSysCache extends BaseExcelCache<CTavern> {
	
	private Map<Integer, List<CTavern>> normalStarMap;
	
	private Map<Integer, List<CTavern>> specialStarMap;
	
	private List<CTavern> allSpecialList;

	@Override
	public String getFileName() {
		return "tavern";
	}

	@Override
	protected void loadAfterReady() {
		Map<Integer, List<CTavern>> tempNormalStarMap = new HashMap<>();
		Map<Integer, List<CTavern>> tempSpecialStarMap = new HashMap<>();
		List<CTavern> tempAllSpecialList = new ArrayList<>();
		
		for(CTavern cTavern : this.getAll()) {
			List<CTavern> normalList = tempNormalStarMap.get(cTavern.getStar());
			if(normalList == null) {
				normalList = new ArrayList<>();
				tempNormalStarMap.put(cTavern.getStar(), normalList);
			}
			List<CTavern> specialList = tempSpecialStarMap.get(cTavern.getStar());
			if(specialList == null) {
				specialList = new ArrayList<>();
				tempSpecialStarMap.put(cTavern.getStar(), specialList);
			}
			if(cTavern.getShow_min() <= 0 && cTavern.getShow_max() <= 0) {
				//普通的任务
				normalList.add(cTavern);
			} else {
				//特殊的任务
				specialList.add(cTavern);
				tempAllSpecialList.add(cTavern);
			}
		}
		this.normalStarMap = tempNormalStarMap;
		this.specialStarMap = tempSpecialStarMap;
		this.allSpecialList = tempAllSpecialList;
	}
	
	public List<CTavern> getNormalList(int star) {
		return normalStarMap.get(star);
	}
	
	public List<CTavern> getSpecialList(int star) {
		return specialStarMap.get(star);
	}
	
	/**
	 * 随机任务数据
	 * 注意：随机过程中会修改refreshCountMap跟limitRefresh的数据
	 * @param refreshCountMap
	 * @param limitRefresh
	 * @param starList
	 * @return
	 */
	public List<CTavern> randomTasks(Map<Integer, Integer> refreshCountMap, Map<Integer, Integer> limitRefresh, List<Integer> starList) {
		List<CTavern> results = new ArrayList<>();
		
		Set<Integer> refreshedSet = new HashSet<>();
		
		for(Integer star : starList) {
			List<CTavern> randomList = new ArrayList<>(normalStarMap.get(star));
			
			List<CTavern> specialList = specialStarMap.get(star);
			for(CTavern cTavern : specialList) {
				int limitCount = limitRefresh.getOrDefault(cTavern.getIdx(), 0);
				if(limitCount >= cTavern.getMax_day()) {
					continue;
				}
				int num = refreshCountMap.getOrDefault(cTavern.getIdx(), 0);
				if(num >= cTavern.getShow_min()) {
					randomList.add(cTavern);
				}
				if(cTavern.getShow_max() > 0 && num >= cTavern.getShow_max()) {
					//必出的情况
					randomList.clear();
					randomList.add(cTavern);
					break;
				}
			}
			CTavern randomOne = DropUtil.randomDrop(randomList);
			results.add(randomOne);
			if(randomOne.getShow_min() > 0 || randomOne.getShow_max() > 0) {
				refreshCountMap.put(randomOne.getIdx(), 0);
				refreshedSet.add(randomOne.getIdx());
			}
			if(randomOne.getMax_day() > 0) {
				int limitCount = limitRefresh.getOrDefault(randomOne.getIdx(), 0);
				limitRefresh.put(randomOne.getIdx(), limitCount + 1);
			}
		}
		
		for(CTavern cTavern : allSpecialList) {
			if(refreshedSet.contains(cTavern.getIdx())) {
				continue;
			}
			int num = refreshCountMap.getOrDefault(cTavern.getIdx(), 0);
			refreshCountMap.put(cTavern.getIdx(), num + 1);
		}
		return results;
	}
	
}