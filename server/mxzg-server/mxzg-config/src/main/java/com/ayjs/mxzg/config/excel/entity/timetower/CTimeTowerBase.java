/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity.timetower;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CTimeTowerBase implements BaseExcelModel {
	private int idx;
	private String struct;
	private String key;
	private String value;
	@Override
	public int getExcelId() {
		return idx;
	}
}
