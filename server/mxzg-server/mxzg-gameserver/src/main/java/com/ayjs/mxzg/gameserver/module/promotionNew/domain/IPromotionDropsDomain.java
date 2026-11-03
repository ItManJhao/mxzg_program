/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.domain;

/**
 * @author YY
 *
 */
public interface IPromotionDropsDomain {
	public long getRid();
	public int getLastDropTime();
	public void setLastDropTime(int lastDropTime);
}
