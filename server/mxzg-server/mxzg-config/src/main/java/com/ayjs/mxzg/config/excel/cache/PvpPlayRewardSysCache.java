package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CPvpPlayReward;
import org.springframework.stereotype.Component;

@Component
public class PvpPlayRewardSysCache extends BaseExcelCache<CPvpPlayReward> {


	@Override
	public String getFileName() {
		return "pvpplayreward";
	}


}