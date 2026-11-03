package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigNotFoundException;
import com.ayjs.mxzg.config.excel.entity.CFirstrewardChapter;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
public class FirstrewardChapterSysCache extends BaseExcelCache<CFirstrewardChapter> {

	private Map<Integer, CFirstrewardChapter> map = new HashMap<>();

	@Override
	public String getFileName() {
		return "firstrewardchapter";
	}

	@Override
	protected void loadAfterReady() {
		List<CFirstrewardChapter> all = getAll();
		for (CFirstrewardChapter cFirstrewardChapter : all) {
			map.put(cFirstrewardChapter.getChapter(), cFirstrewardChapter);
		}
	}

	/**
	 * 根据关卡获取首胜奖励
	 * @param chapterId
	 * @return
	 */
	public CFirstrewardChapter getChapterOrThrow(int chapterId){
		CFirstrewardChapter cFirstrewardChapter = map.get(chapterId);
		if(cFirstrewardChapter != null){
			return cFirstrewardChapter;
		}
		throw new ConfigNotFoundException(String.format("CFirstrewardChapter配置数据不存在chapterId{%s}", chapterId));
	}

}