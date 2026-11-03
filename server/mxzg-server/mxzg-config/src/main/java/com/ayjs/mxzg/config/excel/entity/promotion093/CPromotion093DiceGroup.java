package com.ayjs.mxzg.config.excel.entity.promotion093;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Getter
@Setter
public class CPromotion093DiceGroup implements BaseExcelModel, IDrop {

    private int group;
    private int weight;

    @Override
    public int getExcelId() {
        return group;
    }

    @Override
    public int getDropId() {
        return group;
    }

    @Override
    public int getRate() {
        return weight;
    }
}
