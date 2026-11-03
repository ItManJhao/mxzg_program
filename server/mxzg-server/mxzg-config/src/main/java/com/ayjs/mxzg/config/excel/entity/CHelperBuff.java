package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.RandomUtils;
import com.ayjs.mxzg.config.struct.*;
import com.google.common.collect.Lists;
import lombok.Getter;

import java.util.Arrays;
import java.util.List;

/**
 * 援助buff
 */
@Getter
public class CHelperBuff implements BaseExcelModel {
	
	public int idx;	
	public int art_id;

	@Override
	public int getExcelId() {
		return idx;
	}

}