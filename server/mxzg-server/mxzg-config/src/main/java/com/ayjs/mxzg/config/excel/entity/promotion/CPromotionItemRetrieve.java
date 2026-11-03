package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 活动道具回收item表
 * @author hyx
 */
@Getter
public class CPromotionItemRetrieve implements BaseExcelModel {

    private int id;

    private String description;

    private int retrieve_item;

    @Override
    public int getExcelId() {
        return id;
    }
}
