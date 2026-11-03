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
public class CItem implements BaseExcelModel {
	private int idx;
	private String note;
	private String name;
	private int type;
	private int place;
	private int rare_mark;
	private int level_require;
	private int use_type;
	private int use_value;
	private int decomposition;
	@Override
	public int getExcelId() {
		return idx;
	}
}
