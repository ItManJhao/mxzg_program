/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CBattleAbility;

/**
 * @author YY
 *
 */
@Component
public class BattleAbilitySysCache extends BaseExcelCache<CBattleAbility> {

	@Override
	public String getFileName() {
		return "battleability";
	}
	
	
	
}
