/**
 * 
 */
package com.ayjs.mxzg.config.excel.cache.timetower;

import java.util.Map;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.entity.timetower.CTimeTowerBase;

import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Component
public class TimeTowerBaseSysCache extends BaseExcelCache<CTimeTowerBase> {

	@Getter
	private int openTime;
	@Getter
	private int endTime;
	@Getter
	private int heart;
	
	private Map<String, CTimeTowerBase> nameMap;
	
	
	@Override
	public String getFileName() {
		return "timetowerbase";
	}

	@Override
	protected void loadAfterReady() {
		this.nameMap = this.fillOneLayerMap(CTimeTowerBase::getKey);
		
		Integer[] openTimes = StringUtil.stringToArray(this.nameMap.get("opentime").getValue(), Integer.class);
		this.openTime = parseTime(openTimes);
		
		Integer[] endTimes = StringUtil.stringToArray(this.nameMap.get("endtime").getValue(), Integer.class);
		this.endTime = parseTime(endTimes);
		this.heart = parseInt0(this.nameMap, "heart");
	}
	
	public static int parseInt0(Map<String, CTimeTowerBase> nameMap, String key) {
        try {
            return Integer.parseInt(nameMap.get(key).getValue());
        } catch (Exception e) {
            log.error("参数{}解释错误，无法转化为int", key);
        }
        return 0;
    }
	
	public static int parseTime(Integer[] times) {
		if(times.length > 4) {
			return 0;
		}
		int[] second = new int[] {TimeDateUtil.ONEDAYINT, TimeDateUtil.ONEHOURINT, TimeDateUtil.ONEMININT, TimeDateUtil.ONESECONDINT};
		int result = 0;
		for(int i = times.length - 1; i >= 0; i--) {
			result += times[i] * second[i];
		}
		return result;
	}
}
