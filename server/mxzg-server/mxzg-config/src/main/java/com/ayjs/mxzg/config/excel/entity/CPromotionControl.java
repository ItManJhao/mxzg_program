/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CPromotionControl implements BaseExcelModel {
	private int id;
	private String description;
	private int open_level;
	private int open_server_day;
	private int time;
	private int clean_time;
	private int interval_time;
	private int cycle_type;
	private int open_time_limit;
	@Override
	public int getExcelId() {
		return id;
	}
}
