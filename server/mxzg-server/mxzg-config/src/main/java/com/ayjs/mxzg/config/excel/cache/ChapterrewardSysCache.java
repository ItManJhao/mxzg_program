package com.ayjs.mxzg.config.excel.cache;


import java.util.List;

import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CChapterreward;

@Component
public class ChapterrewardSysCache extends BaseExcelCache<CChapterreward> {


	@Override
	public String getFileName() {
		return "chapterreward";
	}


	/**
	 * 获取章节信息
	 * @param missionId
	 * @param modeId
	 * @param chapterId
	 * @return
	 */
	public CChapterreward getChapterReward(int missionId, int modeId, int chapterId){
		List<CChapterreward> all = getAll();
		for(CChapterreward chapter : all){
			if(missionId == chapter.getMission_id() && modeId == chapter.getMode_id() && chapterId == chapter.getChapter_id()){
				return chapter;
			}
		}
		return null;
	}

}