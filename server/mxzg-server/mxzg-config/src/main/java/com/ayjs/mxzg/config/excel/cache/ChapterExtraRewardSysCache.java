package com.ayjs.mxzg.config.excel.cache;


import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CChapterExtraReward;

@Component
public class ChapterExtraRewardSysCache extends BaseExcelCache<CChapterExtraReward> {


	@Override
	public String getFileName() {
		return "chapterextrareward";
	}


}