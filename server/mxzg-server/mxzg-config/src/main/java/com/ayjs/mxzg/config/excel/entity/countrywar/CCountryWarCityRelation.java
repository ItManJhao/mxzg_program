package com.ayjs.mxzg.config.excel.entity.countrywar;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Getter
public class CCountryWarCityRelation implements BaseExcelModel {

    private int city_id;
    private List<Integer> connect_city_id;


    @Override
    public int getExcelId() {
        return city_id;
    }
}
