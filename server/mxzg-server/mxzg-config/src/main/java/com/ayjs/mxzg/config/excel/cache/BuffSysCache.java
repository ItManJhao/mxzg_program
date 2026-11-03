package com.ayjs.mxzg.config.excel.cache;


import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CBuff;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Set;

@Slf4j
@Component
public class BuffSysCache extends BaseExcelCache<CBuff> {

	@Autowired
	private BuffArtSysCache buffArtSysCache;

	@Override
	public String getFileName() {
		return "buff";
	}

	@Override
	public void loadAfterAllReady() {		
		Set<Integer> allBuffIds = buffArtSysCache.getBuffIds();
		List<CBuff> allBuffs = getAll();
		for(CBuff buff : allBuffs){
			if(!allBuffIds.contains(buff.getIdx())){
				log.info("buff:{}没有被调用", buff.getIdx());
			}
		}
	}

}