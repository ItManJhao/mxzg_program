/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.excel.cache.ClanWorldBossStageSysCache.ICClanWorldBossStage;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CClanWorldBossStage implements BaseExcelModel, ICClanWorldBossStage {
	private int idx;
	private int forecast_time;
	private int challenge_time;
	private int rob_time;
	private int space_time;
	private int challenge_cd;
	private int max_challenge;
	private int rob_cd;
	private int max_rob;
	
	@Override
	public int getExcelId() {
		return idx;
	}
}
