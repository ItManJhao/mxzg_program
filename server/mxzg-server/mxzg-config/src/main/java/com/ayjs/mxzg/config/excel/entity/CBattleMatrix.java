/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.UnlockCondition;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CBattleMatrix implements BaseExcelModel {
	private int idx;
	private int level;
	private UnlockCondition unlockCondition;
	
	@Override
	public int getExcelId() {
		return idx;
	}
}
