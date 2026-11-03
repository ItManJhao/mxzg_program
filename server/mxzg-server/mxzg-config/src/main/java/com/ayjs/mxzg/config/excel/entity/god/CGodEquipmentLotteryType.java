/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity.god;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import com.ayjs.mxzg.common.util.IDrop;
import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CGodEquipmentLotteryType implements BaseExcelModel, IDrop {
	private int idx;
	private int type;
	private int weight;

	@Override
	public int getExcelId() {
		return idx;
	}

	@Override
	public int getDropId() {
		return idx;
	}

	@Override
	public int getRate() {
		return weight;
	}
}
