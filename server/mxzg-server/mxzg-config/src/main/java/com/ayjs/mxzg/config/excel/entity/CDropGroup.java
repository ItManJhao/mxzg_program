package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 掉落组
 */
@Getter
public class CDropGroup implements BaseExcelModel {
    /**
     * 序列
     */
    private int idx;
    /**
     * 触发器id
     */
    private int drop_trigger_id;
    /**
     * 道具type
     */
    private int item_type;
    /**
     * 权重
     */
    private int chance;
    /**
     * 最小值
     */
    private int item_min;
    /**
     * 最大值
     */
    private int item_max;

    @Override
    public int getExcelId() {
        return idx;
    }
}
