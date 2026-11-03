package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CLotteryPoint;
import org.springframework.stereotype.Component;

@Component
public class LotteryPointSysCache extends BaseExcelCache<CLotteryPoint> {


	@Override
	public String getFileName() {
		return "lotterypoint";
	}


}