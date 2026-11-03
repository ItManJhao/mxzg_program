/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CDragonLevel;

/**
 * @author YY
 *
 */
@Component
public class DragonLevelSysCache extends BaseExcelCache<CDragonLevel> {

	private int maxLevel;
	
	@Override
	public String getFileName() {
		return "dragonlevel";
	}

	@Override
	protected void loadAfterReady() {
		int maxLevel = 0;
		for(CDragonLevel level : this.getAll()) {
			if(level.getIdx() > maxLevel) {
				maxLevel = level.getIdx();
			}
		}
		this.maxLevel = maxLevel;
	}

	public int getMaxLevel() {
		return maxLevel;
	}
}
