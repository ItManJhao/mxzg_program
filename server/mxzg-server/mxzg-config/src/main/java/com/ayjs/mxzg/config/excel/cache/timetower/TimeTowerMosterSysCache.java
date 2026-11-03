/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.timetower;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.timetower.CTimeTowerMoster;

/**
 * @author YY
 *
 */
@Component
public class TimeTowerMosterSysCache extends BaseExcelCache<CTimeTowerMoster> {
	
	private Map<Integer, List<CTimeTowerMoster>> monsterMap;
	
	@Override
	public String getFileName() {
		return "timetowermoster";
	}

	@Override
	protected void loadAfterReady() {
		this.monsterMap = this.fillListMap(CTimeTowerMoster::getMission);
	}
	
	public List<CTimeTowerMoster> getByMission(int mission) {
		return monsterMap.get(mission);
	}
}
