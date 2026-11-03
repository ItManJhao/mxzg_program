package com.ayjs.mxzg.config.excel.entity.heroEquipSoul;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2021/3/8
 **/
@Getter
public class CHeroEquipSoulExtra implements BaseExcelModel {

    private int idx;
    private int need_star;
    private int need_equip_rare;
    private int need_equip_star;

    @Override
    public int getExcelId() {
        return idx;
    }
}
