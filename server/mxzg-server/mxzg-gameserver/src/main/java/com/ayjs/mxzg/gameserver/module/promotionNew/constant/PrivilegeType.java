/**
 *
 */
package com.ayjs.mxzg.gameserver.module.promotionNew.constant;

import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.template.constant.ErrorCode;

/**
 * @author YY
 * 特权类型
 */
public enum PrivilegeType {

    XIANZHI_CRYSTAL(100100, "先知水晶"),
    FAST_BATTLE(100200, "快速作战"),
    GOD_EQUIP(100210, "神装特权"),
    ROLE_EXP(100300, "冒险家特权"),
    HERO_EXP(100400, "冒险经验特权"),
    GOLD(100500, "冒险金币特权"),
    BUY_GOLD(100600, "冒险点金特权"),
    IDLE_ROLE_HERO_EXP(100610, "冒险金币特权"),// 挂机角色经验，英雄经验
    IDLE_GOLD_BUY_GOLD(100620, "冒险点金特权"),// 挂机金币，点金金币
    TAVERN_HIGH(100700, "高级酒馆特权"),
    TAVERN_LUXURY(100800, "豪华酒馆特权"),
    DRAGON_LUXURY(100900, "圣龙特权"),
    PLANE_WAR(101000, "位面之战"),
    ;
    private final int value;
    private final String name;


    private PrivilegeType(int value, String name) {
        this.value = value;
        this.name = name;
    }

    public int getValue() {
        return value;
    }

    public String getName() {
        return name;
    }

    public static PrivilegeType valueOf(int type) {
        for (PrivilegeType privilegeType : values()) {
            if (privilegeType.getValue() == type) {
                return privilegeType;
            }
        }
        throw new ErrorCodeException(ErrorCode.TERRIBLE_ERROR.getValue(), "不存在该特权类型：" + type);
    }
}
