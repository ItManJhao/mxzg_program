/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.timetower;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.timetower.CTimeTowerMark;

/**
 * @author YY
 *
 */
@Component
public class TimeTowerMarkSysCache extends BaseExcelCache<CTimeTowerMark> {

	@Override
	public String getFileName() {
		return "timetowermark";
	}

	
	public int getMark(int round) {
		for(CTimeTowerMark config : this.getAll()) {
			if(config.getRound_max() <= round && (config.getRound_min() == 0 || round <= config.getRound_min())) {
				return config.getMark();
			}
		}
		return this.getAll().get(this.getAll().size() - 1).getMark();
	}
}
