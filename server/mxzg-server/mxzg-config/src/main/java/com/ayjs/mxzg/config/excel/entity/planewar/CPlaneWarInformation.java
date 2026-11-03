package com.ayjs.mxzg.config.excel.entity.planewar;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/9/15
 **/
@Getter
public class CPlaneWarInformation implements BaseExcelModel {
    private int element;
    private List<Integer> open_day;
    private int battle_type;

    @Override
    public int getExcelId() {
        return element;
    }

}
