package com.ayjs.mxzg.gameserver.module.backpack.constant;

import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.template.constant.ErrorCode;

/**
 * 装备类型
 */
public enum EquipmentType {
    /**
     * 武器
     */
    WEAPON(1),
    /**
     * 头盔
     */
    HELMET(2),
    /**
     * 铠甲
     */
    CLOTHES(3),
    /**
     * 鞋子
     */
    SHOES(4);

    private int value;

    EquipmentType(int value) {
        this.value = value;
    }

    public static EquipmentType of(int value) {
        EquipmentType result = null;
        for (EquipmentType type : EquipmentType.values()) {
            if (type.value == value) {
                result = type;
                break;
            }
        }
        Asserts.notNull(result, ErrorCode.ERROR_PARAM.getValue(), () -> String.format("获取装备类型出错，value={%d}", value));
        return result;
    }

    public int getValue() {
        return this.value;
    }
}
