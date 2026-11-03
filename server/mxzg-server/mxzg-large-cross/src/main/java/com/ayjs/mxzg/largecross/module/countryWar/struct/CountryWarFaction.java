package com.ayjs.mxzg.largecross.module.countryWar.struct;

/**
 * @Author: CWJ
 * @Date: 2021/4/13
 **/
public enum CountryWarFaction {

    FACTION_1(1),
    FACTION_2(1 << 1),
    FACTION_3(1 << 2),
    FACTION_4(1 << 3),
    /***
     * 联合阵营
     */
    FACTION_ALL(1 << 4),
    ;
    private int value;

    CountryWarFaction(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }

    public static CountryWarFaction valueOf(int value) {
        if ((value & FACTION_ALL.getValue()) == FACTION_ALL.getValue()) {
            return FACTION_ALL;
        }
        for (CountryWarFaction faction : CountryWarFaction.values()) {
            if ((faction.getValue() & value) > 0) {
                return faction;
            }
        }
        throw new RuntimeException("不存在该枚举值：" + value);
    }

}
