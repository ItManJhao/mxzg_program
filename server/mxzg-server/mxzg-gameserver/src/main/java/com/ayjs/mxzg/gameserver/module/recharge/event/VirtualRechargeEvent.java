/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.recharge.event;

import lombok.Value;

/**
 * @author YY
 *
 */
@Value(staticConstructor = "of")
public class VirtualRechargeEvent {
	private long rid;
	// 商品id
	private int productId;
	
	private int success;
	// 是否是充值卡购买
	private int card;
}
