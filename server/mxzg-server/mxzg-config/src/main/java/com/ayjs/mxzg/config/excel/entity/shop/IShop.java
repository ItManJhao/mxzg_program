/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity.shop;

import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

/**
 * @author YY
 *
 */
public interface IShop extends IDrop {
	
	public int getIdx();
	public int getChance();
	public ImmutableList<ImmutableThing> getItem_type();
	public ImmutableList<ImmutableThing> getNeed_item();
	public int getLimit_type();
	public int getBuy_limit();
	
	@Override
	default int getDropId() {
		return getIdx();
	}

	@Override
	default int getRate() {
		return getChance();
	}
}
