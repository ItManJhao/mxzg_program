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
public class CDragonRelic implements BaseExcelModel {
	private int relic_type;
	private int kind;
	private int star;
	private int up_star_type;
	private ImmutableList<ImmutableThing> up_star_require;
	private ImmutableMap<AttributeType, Long> ability;
	private int skill;
	private ImmutableList<ImmutableThing> sell;
	@Override
	public int getExcelId() {
		return relic_type;
	}
}
