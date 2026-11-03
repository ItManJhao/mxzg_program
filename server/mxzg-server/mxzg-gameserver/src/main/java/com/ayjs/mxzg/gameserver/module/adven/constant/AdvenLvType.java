package com.ayjs.mxzg.gameserver.module.adven.constant;

/**
 * 难度类型
 *
 * @Author: CWJ
 * @Date: 2020/2/29
 **/
public enum AdvenLvType {

    /**
     * 普通
     */
    NORMAL(1),
    /**
     * 精英
     */
    HIGH(2),
    /**
     * 噩梦
     */
    NIGHTMARE(3),

    ;
    private int lv;

    AdvenLvType(int lv) {
        this.lv = lv;
    }

    public int getLv() {
        return lv;
    }

    public static AdvenLvType lvOf(int lv) {
        for (AdvenLvType advenLvType : AdvenLvType.values()) {
            if (advenLvType.getLv() == lv)
                return advenLvType;
        }
        return null;
    }
}
