/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.timetower;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.timetower.CTimeTowerMisson;

/**
 * @author YY
 *
 */
@Component
public class TimeTowerMissonSysCache extends BaseExcelCache<CTimeTowerMisson> {

	@Override
	public String getFileName() {
		return "timetowermisson";
	}

	public List<CTimeTowerMisson> getJumps(int currLayer) {
		List<CTimeTowerMisson> result = new ArrayList<>();
		for(CTimeTowerMisson config : this.getAll()) {
			if(config.getMission() > currLayer) {
				if(config.getType() > 1) {
					break;
				}
				result.add(config);
			}
		}
		return result;
	}
}
