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
public class CDragonIdentify implements BaseExcelModel {
	private int idx;
	private int speed;
	private String upgrade_require;
	private long need_recharge;
	@Override
	public int getExcelId() {
		return idx;
	}
}
