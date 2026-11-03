/**
 * 
 */
package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

/**
 * @author YY
 * 活动掉落的逻辑，龙纹印记、七彩华章、诸神之战
 */
public interface IPromotionConfigDrops {
	public ImmutableList<ImmutableThing> getReward();
	public int getGain_frequency();
	public int getGain_chance();
}
