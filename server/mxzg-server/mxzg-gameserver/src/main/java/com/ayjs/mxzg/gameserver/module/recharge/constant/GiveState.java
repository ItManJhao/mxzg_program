/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.recharge.constant;

/**
 * @author YY
 * 充值发货状态
 */
public enum GiveState {
	UNHANDLE(0), //待处理
	SUCCESS(1),//金额一致发货成功
	SUCCESS_HALF(2),//金额不一致发货成功
	FAIL(3),//失败
	;
	private final int type;
	private GiveState(int type) {
		this.type = type;
	}
	public int getType() {
		return type;
	}
}
