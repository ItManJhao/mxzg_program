package com.ayjs.mxzg.config.excel.entity.floatingIslands;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.RunesVo;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/6/30
 **/
@Getter
@Setter
public class CFloatingIslandsHero implements BaseExcelModel, HeroConfig {

    private int idx;
//    private int turns;
    private int pos;
    private int hero_type;
    private int hero_level;
    private int hero_star;
    private ImmutableList<AttributeKind> attr;
    private ImmutableList<EquipInfo> equipment;
    private ImmutableList<RunesVo> runes;

    @Override
    public int getExcelId() {
        return idx;
    }


}
