/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;


@Getter
public class CTopMatchSecondSeason implements BaseExcelModel {
	private int idx;
	private int type;
	private int start_day;
	private int start_time;
	private int last_day;
	private int biu_count;
	private int biu_cd;
	private int biu_len;
	private int guess;
	private int guess_add;
	@Override
	public int getExcelId() {
		return idx;
	}
}
