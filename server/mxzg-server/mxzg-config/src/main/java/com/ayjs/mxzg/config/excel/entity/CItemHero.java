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
public class CItemHero implements BaseExcelModel {
	private int type;
	private int hero_type;
	private int star;
	@Override
	public int getExcelId() {
		return type;
	}
}
