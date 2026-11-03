/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CChampionRobotRole;

/**
 * @author YY
 *
 */
@Component
public class ChampionRobotRoleSysCache extends BaseExcelCache<CChampionRobotRole> {

	@Override
	public String getFileName() {
		return "championrobotrole";
	}
	
}
