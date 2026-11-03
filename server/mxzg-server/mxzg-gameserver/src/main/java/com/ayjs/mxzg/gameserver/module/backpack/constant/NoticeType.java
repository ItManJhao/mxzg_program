/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.backpack.constant;

/**
 * @author YY
 *
 */
public enum NoticeType {
	/**
	 * 沉默方式，更新前端不做任何显示
	 */
	SLIENT(0),
	/**
	 * 普通方式，更新前端并弹窗
	 */
	NORMAL(1),
	/**
	 * 飘字方式，更新前端并飘字
	 */
	TIPS(2),
	/**
	 * 后续完善
	 */
	LAZY(999),
	;
	private final int value;
	private NoticeType(int value) {
		this.value = value;
	}
	public int getValue() {
		return value;
	}
}
