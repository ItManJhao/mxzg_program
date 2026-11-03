package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 邀请码数据
 *
 */
@Getter
public class CPromotionInvite implements BaseExcelModel {

	private int idx;

	private int type;

	private int num;

    private ImmutableList<ImmutableThing> reward;

	private int gain_limit;

	@Override
	public int getExcelId() {
		return idx;
	}
}

