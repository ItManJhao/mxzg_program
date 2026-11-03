package com.ayjs.mxzg.gameserver.module.growthGiftBag.constant;

/**
 * 成长礼包类型
 */
public enum GrowthGiftType {

    BUY_GIFT(1),//需购买的成长礼包类型

    DECORATE_GIFT(2)//达到充值额度免费领取的成长礼包类型
    ;

    private int type;

    GrowthGiftType(int type) {
        this.type = type;
    }

    public int getType() {
        return type;
    }
}
