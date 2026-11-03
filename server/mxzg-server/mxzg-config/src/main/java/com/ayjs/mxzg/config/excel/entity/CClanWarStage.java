/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.excel.cache.ClanWarStageSysCache.ICClanWarStage;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CClanWarStage implements BaseExcelModel, ICClanWarStage {
	private int idx;
	private int match_time;
	private int prepare_time;
	private int adjust_time;
	private int space_time;
	private int battle_time;
	private int need_active;
	private int grow_rate;
	@Override
	public int getExcelId() {
		return idx;
	}
}
