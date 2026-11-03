package com.ayjs.mxzg.config.excel.entity.runeStone;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 符石阵法解锁
 *
 * @Author: CWJ
 * @Date: 2020/7/29
 **/
@Getter
public class CRuneStoneMatrixUnlock implements BaseExcelModel {

    private int place;
    private int intensify;

    @Override
    public int getExcelId() {
        return place;
    }
}
