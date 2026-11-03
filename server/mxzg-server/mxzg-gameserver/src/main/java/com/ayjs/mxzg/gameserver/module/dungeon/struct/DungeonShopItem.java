package com.ayjs.mxzg.gameserver.module.dungeon.struct;

/**
 * 庇护所商店物品类
 */
public class DungeonShopItem {

    private long shopId;

    private int itemId;

    private int index;

    private int isBuy;//商品购买状态。0为未购买，1为已购买

    public long getShopId() {
        return shopId;
    }

    public void setShopId(long shopId) {
        this.shopId = shopId;
    }

    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public int getIsBuy() {
        return isBuy;
    }

    public void setIsBuy(int isBuy) {
        this.isBuy = isBuy;
    }
}
