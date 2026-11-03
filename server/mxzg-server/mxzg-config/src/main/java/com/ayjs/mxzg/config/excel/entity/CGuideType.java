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
public class CGuideType implements BaseExcelModel {
	private int idx;
	private int type;
	private String subtype;
	@Override
	public int getExcelId() {
		return idx;
	}
}
