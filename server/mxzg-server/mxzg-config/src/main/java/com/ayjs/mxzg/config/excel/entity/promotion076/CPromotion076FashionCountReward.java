package com.ayjs.mxzg.config.excel.entity.promotion076;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import lombok.Getter;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Getter
public class CPromotion076FashionCountReward implements BaseExcelModel {

    private int idx;

    private List<ImmutableThing> need_item;

    private List<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
