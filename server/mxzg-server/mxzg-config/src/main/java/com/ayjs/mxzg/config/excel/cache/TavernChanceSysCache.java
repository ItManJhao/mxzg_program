package com.ayjs.mxzg.config.excel.cache;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.constant.TavernConst;
import com.ayjs.mxzg.config.excel.entity.CTavernChance;

@Component
public class TavernChanceSysCache extends BaseExcelCache<CTavernChance> {

	@Override
	public String getFileName() {
		return "tavernchance";
	}

	
	public List<Integer> randomStar(int refreshCount, List<Integer> privilegeList) {
		//每N次必出一个指定配置的星级任务
		int taskNum = TavernConst.NUM;
		
		Map<Integer, Integer> starNumMap = new HashMap<>();
		//特权的星级任务
		for(Integer star : privilegeList) {
			int num = starNumMap.getOrDefault(star, 0);
			starNumMap.put(star, num + 1);
			taskNum--;
		}
		
		for(CTavernChance chance : this.getAll()) {
			if(chance.getFlash_show() <= 0) {
				continue;
			}
			if(refreshCount % chance.getFlash_show() == 0) {
				int num = starNumMap.getOrDefault(chance.getStar(), 0);
				if(num < chance.getFlash_max()) {
					starNumMap.put(chance.getStar(), num + 1);
					taskNum--;
				}
			}
		}
		for(int i = 0; i < taskNum; i++) {
			List<CTavernChance> randomList = new ArrayList<>();
			for(CTavernChance chance : this.getAll()) {
				if(chance.getFlash_max() <= 0) {
					randomList.add(chance);
				} else {
					int num = starNumMap.getOrDefault(chance.getStar(), 0);
					if(num < chance.getFlash_max()) {
						randomList.add(chance);
					}
				}
			}
			CTavernChance randomOne = DropUtil.randomDrop(randomList);
			int num = starNumMap.getOrDefault(randomOne.getStar(), 0);
			starNumMap.put(randomOne.getStar(), num + 1);
		}
		
		List<Integer> list = new ArrayList<>();
		for(Entry<Integer, Integer> entry : starNumMap.entrySet()) {
			//往结果列表中添加m个n星的任务，m=entry.getValue，n=entry.getKey
			for(int i = 0; i < entry.getValue(); i++) {
				list.add(entry.getKey());
			}
		}
		return list;
	}
}