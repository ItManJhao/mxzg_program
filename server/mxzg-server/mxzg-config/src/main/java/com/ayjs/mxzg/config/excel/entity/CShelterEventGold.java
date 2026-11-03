package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 *  庇护所金币资源配置
 */
@Getter
public class CShelterEventGold implements BaseExcelModel {
	
	private int idx;
	
	private ImmutableList<ImmutableThing> base;//起始值
	
	private ImmutableList<ImmutableThing> add;//每加一层的增加量

	@Override
	public int getExcelId() {
		// TODO Auto-generated method stub
		return idx;
	}
}
