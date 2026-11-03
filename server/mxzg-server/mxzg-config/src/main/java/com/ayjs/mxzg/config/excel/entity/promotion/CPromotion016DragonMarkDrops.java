package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 限时掉落
 * 龙鳞印记掉落
 * 
 */
@Getter
public class CPromotion016DragonMarkDrops implements BaseExcelModel, IPromotionConfigDrops {
	
	private int idx;
	private int turns;
    private ImmutableList<ImmutableThing> reward;
	private int gain_frequency;
	private int gain_chance;
	@Override
	public int getExcelId() {
		return idx;
	}
}
