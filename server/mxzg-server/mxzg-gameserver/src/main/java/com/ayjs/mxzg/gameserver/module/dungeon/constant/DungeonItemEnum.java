package com.ayjs.mxzg.gameserver.module.dungeon.constant;


/**
 * 地牢特殊道具枚举
 */
public enum DungeonItemEnum {

    BOX_KEY(901601),    //宝箱钥匙
    SHOP_AGENTIA(901604),     //召唤商人药剂
    ;

    public int getItemType() {
        return itemType;
    }

    private int itemType;

    DungeonItemEnum(int itemType){ this.itemType = itemType;}
}
