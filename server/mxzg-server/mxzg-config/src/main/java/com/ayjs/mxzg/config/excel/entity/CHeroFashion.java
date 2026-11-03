package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 英雄皮肤(时装)
 * @author hyx
 */
@Getter
public class CHeroFashion implements BaseExcelModel {

    private int fashion_id;

    private int hero_type;

    private String fashion_name;

    private int skill;

    private int skill_level;

    @Override
    public int getExcelId() {
        return fashion_id;
    }
}
