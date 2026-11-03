package com.ayjs.mxzg.config.excel.cache;


import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigNotFoundException;
import com.ayjs.mxzg.config.excel.entity.CHeroUpGrade;

import lombok.Getter;

@Component
public class HeroUpGradeSysCache extends BaseExcelCache<CHeroUpGrade> {

	@Getter
	private int maxLevel;
	@Getter
	private int maxGrade;

	@Override
	public String getFileName() {
		return "heroupgrade";
	}
	
	/**
	 * 根据等级获取最高的升阶信息
	 * @param level
	 * @return
	 */
	public CHeroUpGrade getHeroUpGradeOrThrow(int level){
		CHeroUpGrade cheroUpGrade = null;
		for(CHeroUpGrade upgrade : getAll()){
			if(level >= upgrade.getBegin_level()){
				if(cheroUpGrade == null || upgrade.getBegin_level() > cheroUpGrade.getBegin_level()){
					cheroUpGrade = upgrade;
				}
			}
		}
		if(cheroUpGrade != null){
			return cheroUpGrade;
		}
		throw new ConfigNotFoundException(String.format("CHeroUpGrade表没有找到对应等级%s的英雄升阶信息", level));
	}

	@Override
	protected void loadAfterReady() {
		int tempMaxLevel = 0;
		int tempMaxGrade = 0;
		for(CHeroUpGrade upgrade : getAll()) {
			if(upgrade.getLevel() > tempMaxLevel) {
				tempMaxLevel = upgrade.getLevel();
			}
			if(upgrade.getGrade() > tempMaxGrade) {
				tempMaxGrade = upgrade.getGrade();
			}
		}
		this.maxLevel = tempMaxLevel;
		this.maxGrade = tempMaxGrade;
	}

}