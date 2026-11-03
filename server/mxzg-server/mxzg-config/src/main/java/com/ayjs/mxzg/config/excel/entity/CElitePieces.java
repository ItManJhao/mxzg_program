package com.ayjs.mxzg.config.excel.entity;


import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

@Getter
public class CElitePieces implements BaseExcelModel {

    private int idx;

    private int item_type;

    private int hero_id;

    private int weight;

    @Override
    public int getExcelId() {
        return idx;
    }
}
