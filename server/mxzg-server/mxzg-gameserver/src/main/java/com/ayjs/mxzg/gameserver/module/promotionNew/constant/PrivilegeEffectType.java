/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.constant;

/**
 * 特权效果类型
 */
public enum PrivilegeEffectType {
    /**
     * 挂机角色经验
     */
    IDLE_ROLE_EXP,
    /**
     * 挂机英雄经验
     */
    IDLE_HERO_EXP,
    /**
     * 挂机金币
     */
    IDLE_GOLD,
    /**
     * 点金
     */
    BUY_GOLD,

    /***
     * 位面之战免费次数
     */
    PLANE_WAR_FREE,

    /***
     * 位面之战购买次数
     */
    PLANE_WAR_BUY,


    ;
//	private final int value;
//	private final String name;


//	private PrivilegeEffectType(int value, String name) {
//		this.value = value;
//		this.name = name;
//	}
//	public int getValue() {
//		return value;
//	}
//	public String getName() {
//		return name;
//	}
//
//	public static PrivilegeEffectType valueOf(int type) {
//        for (PrivilegeEffectType privilegeType : values()) {
//            if (privilegeType.getValue() == type) {
//                return privilegeType;
//            }
//        }
//        throw new ErrorCodeException(ErrorCode.TERRIBLE_ERROR.getValue(), "不存在该特权类型：" + type);
//    }
}
