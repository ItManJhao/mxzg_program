package com.ayjs.mxzg.gameserver.module.border.constant;

/**
 * @Author: CWJ
 * @Date: 2019/10/28
 **/
public enum BorderActiveType {
    /**
     * 免费激活
     */
    FREE(1),
    /**
     * 道具激活
     */
    ITEM(2),
    /**
     * 条件激活
     */
    COMPLETE(3);
    private int type;

    BorderActiveType(int type) {
        this.type = type;
    }

    public int getType() {
        return type;
    }
}
