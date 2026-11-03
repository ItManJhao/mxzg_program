package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CClanBossRankReward;
import org.springframework.stereotype.Component;

@Component
public class ClanBossRankRewardSysCache extends BaseExcelCache<CClanBossRankReward> {


	@Override
	public String getFileName() {
		return "clanbossrankreward";
	}


}