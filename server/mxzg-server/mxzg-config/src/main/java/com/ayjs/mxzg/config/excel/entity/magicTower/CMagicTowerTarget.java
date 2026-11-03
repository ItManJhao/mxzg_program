package com.ayjs.mxzg.config.excel.entity.magicTower;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.GodRelicTarget;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Getter
public class CMagicTowerTarget implements BaseExcelModel {

    private int idx;
    private GodRelicTarget target;


    @Override
    public int getExcelId() {
        return idx;
    }


}
