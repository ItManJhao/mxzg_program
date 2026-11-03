/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.google.common.collect.ImmutableMap;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CTitle implements BaseExcelModel {
	private int idx;
	private String name;
	private int type;
	private ImmutableMap<AttributeType, Long> ability;
	private String condition;
	private int[] rankCondition;
	private int time;
	@Override
	public int getExcelId() {
		return idx;
	}
	public void setRankCondition(int[] rankCondition) {
		this.rankCondition = rankCondition;
	}
}
