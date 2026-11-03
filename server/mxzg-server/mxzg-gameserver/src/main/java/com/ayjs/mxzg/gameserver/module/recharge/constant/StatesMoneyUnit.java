package com.ayjs.mxzg.gameserver.module.recharge.constant;

import lombok.extern.slf4j.Slf4j;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * 地区货币类型
 */
@Slf4j
public enum StatesMoneyUnit {
    RMB(1),//人民币
    USD(2),//美元
    TWD(3),//台湾
    HKD(4),//香港
    MOP(5),//澳门
    SGD(6),//新加坡
    MYR(7),//马来西亚
    VND(8),//越南盾
    THB(9),//泰铢
    IDR(10),//卢比
    PHP(11),//比索

    ;
    private final int type;

    private static Map<Integer, StatesMoneyUnit> ENUMS = new HashMap<>();
    private static Map<String, StatesMoneyUnit> unitMap = new HashMap<>();

    StatesMoneyUnit(int type) {
        this.type = type;
    }

    static {
        for (StatesMoneyUnit statesMoneyUnit : StatesMoneyUnit.values()) {
            if (ENUMS.containsKey(statesMoneyUnit.getType())) {
                log.warn("states Money Unit duplicate:{},{}", ENUMS.get(statesMoneyUnit.getType()), statesMoneyUnit);
                continue;
            }
            ENUMS.put(statesMoneyUnit.getType(), statesMoneyUnit);
            unitMap.put(statesMoneyUnit.name(), statesMoneyUnit);
        }
    }

    public int getType() {
        return type;
    }

    public static StatesMoneyUnit valueOf(int value) {
        return ENUMS.get(value);
    }

    public static StatesMoneyUnit nameOf(String name) {
        if (Objects.isNull(name)) {
            return null;
        }
        return unitMap.get(name.toUpperCase());
    }
}
