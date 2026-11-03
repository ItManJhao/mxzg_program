package com.ayjs.mxzg.config.excel.entity.promotion093;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Getter
public class CPromotion093DicePoint implements BaseExcelModel {

    private int idx;
    private int group;
    private int dice_count;
    private int dice_point;


    @Override
    public int getExcelId() {
        return idx;
    }


}
