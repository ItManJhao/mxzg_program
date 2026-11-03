/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CBattleFormation;

/**
 * @author YY
 *
 */
@Component
public class BattleFormationSysCache extends BaseExcelCache<CBattleFormation> {

	@Override
	public String getFileName() {
		return "battleformation";
	}
}
