/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @author YY
 *
 */
@Getter
public class CPromotion015NewSeverLimitGift implements BaseExcelModel {
	private int idx;
	private int turns;
	private int production_id;
    private ImmutableList<ImmutableThing> gift_reward;
	private int buy_limit;
	@Override
	public int getExcelId() {
		return idx;
	}
}
