package com.ayjs.mxzg.gameserver.module.blessingPool.domain;

import com.ayjs.mxzg.common.util.IDrop;
import lombok.Data;

@Data
public class BlessingPoolItemData implements IDrop {
    /**
     * 位置
     */
    private int position;
    /**
     * 物品类型
     */
    private int itemType;
    /**
     * 物品数量
     */
    private long itemNumber;
    /**
     * 概率
     */
    private int chance;
    /**
     * 抽中次数
     */
    private int times;

    /***
     * 配置id
     * @return
     */
    private int configIdx;

    @Override
    public int getDropId() {
        return getItemType();
    }

    @Override
    public int getRate() {
        return getChance();
    }
}
