/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity;

import java.util.List;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Multimap;

import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CElementAddition implements BaseExcelModel {
	private int idx;
	private int type;
	private List<Integer> elements;
	private ImmutableMap<AttributeType, Long> ability;
	private Multimap<Integer, Integer> elementMap = ArrayListMultimap.create();
	@Override
	public int getExcelId() {
		return idx;
	}
	
}
