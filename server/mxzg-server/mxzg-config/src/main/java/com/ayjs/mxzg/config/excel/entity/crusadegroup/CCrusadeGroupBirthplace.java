package com.ayjs.mxzg.config.excel.entity.crusadegroup;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 讨伐团出生点表
 */
@Getter
public class CCrusadeGroupBirthplace implements BaseExcelModel {

    /**
     * 主键
     */
    private int idx;
    /**
     * 出生点领地id
     */
    private int birth_id;


    @Override
    public int getExcelId(){ return idx;
    }
}
