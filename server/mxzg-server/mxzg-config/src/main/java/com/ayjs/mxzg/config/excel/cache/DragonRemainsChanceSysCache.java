/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.entity.CDragonRemainsChance;

/**
 * @author YY
 *
 */
@Component
public class DragonRemainsChanceSysCache extends BaseExcelCache<CDragonRemainsChance> {
	
	private Map<Integer, List<CDragonRemainsChance>> levelMap;
	
	@Override
	public String getFileName() {
		return "dragonremainschance";
	}

	@Override
	protected void loadAfterReady() {
		this.levelMap = this.fillListMap(CDragonRemainsChance::getLevel);
	}

	/**
	 * 按照等级随机一个奖励
	 * @param level
	 * @return
	 */
	public CDragonRemainsChance getChance(int level, int num) {
		List<CDragonRemainsChance> chanceList = levelMap.get(level);
		
		//必出列表
		List<CDragonRemainsChance> sureList = new ArrayList<>();
		//随机列表
		List<CDragonRemainsChance> rollList = new ArrayList<>();
		for(CDragonRemainsChance chance : chanceList) {
			if(num >= chance.getMin_num()) {
				rollList.add(chance);
			}
			if(chance.getMax_num() > 0 && num >= chance.getMax_num()) {
				sureList.add(chance);
			}
		}
		if(!sureList.isEmpty()) {
			return DropUtil.randomDrop(sureList);
		}
		return DropUtil.randomDrop(rollList);
	}
}
