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
public class CCrossServerName implements BaseExcelModel {
	private int idx;
	private int platform_id;
	private int platform_son_id;
	private int server_id_difference;
	@Override
	public int getExcelId() {
		return idx;
	}
}
