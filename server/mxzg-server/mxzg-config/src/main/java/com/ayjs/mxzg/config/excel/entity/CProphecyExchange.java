package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 先知置换
 */
@Getter
public class CProphecyExchange implements BaseExcelModel {
    /**
     * 唯一id
     */
    private int idx;
    /**
     * 元素
     */
    private int element;
    /**
     * 星级
     */
    private int star;
    /**
     * 奖励组
     */
    private int group_id;
    /**
     * 出现权重
     */
    private int weight;
    /**
     * 注释
     */
    private String note;

    @Override
    public int getExcelId() {
        return idx;
    }
}
