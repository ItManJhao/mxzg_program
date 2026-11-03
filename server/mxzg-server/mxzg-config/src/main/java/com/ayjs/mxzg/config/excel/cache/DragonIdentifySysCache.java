/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CDragonIdentify;

/**
 * @author YY
 *
 */
@Component
public class DragonIdentifySysCache extends BaseExcelCache<CDragonIdentify> {

	private int maxLevel;
	
	@Override
	public String getFileName() {
		return "dragonidentify";
	}

	@Override
	protected void loadAfterReady() {
		int maxLevel = 0;
		for(CDragonIdentify identify : this.getAll()) {
			if(identify.getIdx() > maxLevel) {
				maxLevel = identify.getIdx();
			}
		}
		this.maxLevel = maxLevel;
	}

	public int getMaxLevel() {
		return maxLevel;
	}
}
