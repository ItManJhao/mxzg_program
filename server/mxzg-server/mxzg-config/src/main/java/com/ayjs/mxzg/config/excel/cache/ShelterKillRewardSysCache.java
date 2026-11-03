package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CShelterKillReward;
import org.springframework.stereotype.Component;

@Component
public class ShelterKillRewardSysCache extends BaseExcelCache<CShelterKillReward> {


	@Override
	public String getFileName() {
		return "shelterkillreward";
	}


}