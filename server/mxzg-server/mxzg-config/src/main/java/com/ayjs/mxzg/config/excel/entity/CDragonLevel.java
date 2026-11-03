/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CDragonLevel implements BaseExcelModel {
	private int idx;
	//level只用于显示
	private int level;
	//grade只用于显示
	private int grade;
	private ImmutableList<ImmutableThing> item_require;
	private ImmutableMap<AttributeType, Long> ability;
	private int relic_unlock;
	private String name;
	@Override
	public int getExcelId() {
		return idx;
	}
}
