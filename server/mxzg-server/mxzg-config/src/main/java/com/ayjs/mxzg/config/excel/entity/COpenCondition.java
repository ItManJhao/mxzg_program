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
public class COpenCondition implements BaseExcelModel {
	private int idx;
	private String atom;
	private int condition_type;
	private int condition_value;
	private int world_level;
	@Override
	public int getExcelId() {
		return idx;
	}
}
