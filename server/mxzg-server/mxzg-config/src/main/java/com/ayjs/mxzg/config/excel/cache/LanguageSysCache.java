package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.common.excel.ConfigAsserts;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import org.springframework.stereotype.Component;

import java.util.Map;

@Component
public class LanguageSysCache extends BaseExcelCache<CLanguage> {



	private Map<String, CLanguage> keyMap;
	
	@Override
	public String getFileName() {
		return "language";
	}

	@Override
	protected void loadAfterReady() {
		this.keyMap = this.fillOneLayerMap(CLanguage::getKey);
	}

	public CLanguage getByKey(String key) {
		CLanguage cLanguage = keyMap.get(key);
		ConfigAsserts.notNull(cLanguage, () -> String.format("无法找到语言表配置：{%s}的数据", key));
		return cLanguage;
	}


}