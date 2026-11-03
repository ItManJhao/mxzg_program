/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CSign;

/**
 * @author YY
 *
 */
@Component
public class SignSysCache extends BaseExcelCache<CSign> {

	private Map<Integer, Map<Integer, CSign>> monthDayMap;
	
	@Override
	public String getFileName() {
		return "sign";
	}

	@Override
	protected void loadAfterReady() {
		this.monthDayMap = this.fillTwoLayerMap(CSign::getMonth, CSign::getDay);
	}
	
	public CSign getByMonthDay(int month, int day) {
		Map<Integer, CSign> dayMap = monthDayMap.get(month);
		if(dayMap == null) {
			return null;
		}
		return dayMap.get(day);
	}

}
