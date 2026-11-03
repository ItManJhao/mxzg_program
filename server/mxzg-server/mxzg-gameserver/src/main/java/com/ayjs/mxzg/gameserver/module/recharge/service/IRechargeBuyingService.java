/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.recharge.service;

import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;

/**
 * @author YY
 * 充值购买接口
 */
public interface IRechargeBuyingService {
	
	public BuyGemType buyGemType();
	/**
	 * 是否可以购买该商品
	 * @param rid
	 * @param productionId
	 * @return
	 */
	public boolean canBuy(long rid, int productId);
	/**
	 * 成功购买商品
	 * @param rid
	 * @param productionId
	 */
	public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm);
}
