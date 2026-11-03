package com.ayjs.mxzg.config.excel.cache;


import org.springframework.stereotype.Component;

import com.ayjs.mxzg.common.excel.BaseExcelCache;
import com.ayjs.mxzg.config.excel.entity.CScoreCount;

@Component
public class ScoreCountSysCache extends BaseExcelCache<CScoreCount> {

	private int atk;
	private int hp;
	private int def;

	@Override
	public String getFileName() {
		return "scorecount";
	}
	
	@Override
	protected void loadAfterReady() {
		for (CScoreCount cScoreCount : this.getAll()) {
	        if (cScoreCount.getType().equals("atk")) {
	            atk = cScoreCount.getRatio();
	        } else if (cScoreCount.getType().equals("hp")) {
	            hp = cScoreCount.getRatio();
	        } else if (cScoreCount.getType().equals("def")) {
	            def = cScoreCount.getRatio();
	        }
	    }
	}

	public int getAtk_ration() {
		return atk;
	}

	public int getHp_ration() {
		return hp;
	}

	public int getDef_ration() {
		return def;
	}
}