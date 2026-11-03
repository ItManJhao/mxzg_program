package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 七彩华章
 * 掉落
 */
@Getter
public class CPromotion044FiresShopDrops implements BaseExcelModel, IPromotionConfigDrops {
	
	private int idx;
    private ImmutableList<ImmutableThing> reward;
	private int gain_frequency;
	private int gain_chance;
	@Override
	public int getExcelId() {
		return idx;
	}
}
