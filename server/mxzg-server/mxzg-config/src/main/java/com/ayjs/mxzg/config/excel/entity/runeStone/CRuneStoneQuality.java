package com.ayjs.mxzg.config.excel.entity.runeStone;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

import java.util.Map;

/**
 * 符石
 *
 * @Author: CWJ
 * @Date: 2020/7/29
 **/
@Getter
public class CRuneStoneQuality implements BaseExcelModel {

    private int quality;
    private Map<Integer, Integer> attr_quality_rate;
    private Map<Integer, Integer> job_rate;
    private Map<Integer, Integer> kind_rate;


    @Override
    public int getExcelId() {
        return quality;
    }
}
