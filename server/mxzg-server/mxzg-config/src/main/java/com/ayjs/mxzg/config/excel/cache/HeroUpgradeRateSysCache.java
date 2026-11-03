/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CHeroUpgradeRate;

/**
 * @author YY
 *
 */
@Component
public class HeroUpgradeRateSysCache extends BaseExcelCache<CHeroUpgradeRate> {

	@Autowired
	private HeroTypeSysCache heroTypeSysCache;
	
	private Map<Integer, Map<Integer, CHeroUpgradeRate>> typeGradeMap;
	
	@Override
	public String getFileName() {
		return "heroupgraderate";
	}

	@Override
	protected void loadAfterReady() {
		this.typeGradeMap = this.fillTwoLayerMap(CHeroUpgradeRate::getHero_id, CHeroUpgradeRate::getGrade);
	}

	@Override
	public boolean check() {
		for(Entry<Integer, Map<Integer, CHeroUpgradeRate>> entry : typeGradeMap.entrySet()) {
			heroTypeSysCache.getOrThrow(entry.getKey());
			//每个英雄0到6阶
			ConfigAsserts.isTrue(entry.getValue().size() == 7, () -> String.format("heroupgraderate表英雄%s等阶成长系数数据不足7条", entry.getKey()));
		}
		return true;
	}
	
	public CHeroUpgradeRate getUpgradeRate(int heroType, int grade) {
		Map<Integer, CHeroUpgradeRate> gradeMap = typeGradeMap.get(heroType);
		ConfigAsserts.notNull(gradeMap, () -> String.format("heroupgraderate没找到英雄%s的数据", heroType));
		CHeroUpgradeRate config = gradeMap.get(grade);
		ConfigAsserts.notNull(gradeMap, () -> String.format("heroupgraderate没找到英雄%s的%s阶数据", heroType, grade));
		return config;
	}
	
}
