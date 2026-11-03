/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPvpRobotRole;

/**
 * @author YY
 *
 */
@Component
public class PvpRobotRoleSysCache extends BaseExcelCache<CPvpRobotRole> {

	@Override
	public String getFileName() {
		return "pvprobotrole";
	}

}
