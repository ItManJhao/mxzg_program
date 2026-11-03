package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 掉落触发器
 */
@Getter
public class CDropTrigger implements BaseExcelModel {
    /**
     * 序列
     */
    private int idx;
    /**
     * 掉落组
     */
    private int drop_group;
    /**
     * 掉落器编号-唯一
     */
    private int drop_trigger_id;
    /**
     * 统计类型
     */
    private int item_group_type;
    /**
     * 触发次数
     */
    private int trigger_times;
    /**
     * 掉落器触发概率（百万分）
     */
    private int trigger_chance;
    /**
     * 多少次不掉后必出1次
     */
    private int drop_trigger_guarantee;
    /**
     * 触发次数上限（周期内） 暂时不用
     */
    private int trigger_max;
    /**
     * 总掉落数量上限（周期内）
     */
    private int drop_item_max;

    @Override
    public int getExcelId() {
        return idx;
    }
}
