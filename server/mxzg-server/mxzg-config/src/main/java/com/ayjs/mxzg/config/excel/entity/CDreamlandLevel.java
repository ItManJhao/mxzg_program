package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.RunesVo;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

import java.util.List;

/**
 * 永恒梦境关卡配置
 *
 * @Author: CWJ
 * @Date: 2019/12/11
 **/
@Getter
public class CDreamlandLevel implements BaseExcelModel, HeroConfig {

    private int idx;
    private int mission_id;
    private int pos;
    private int hero_type;
    private int hero_level;
    private int hero_star;
    private List<AttributeKind> attr;
    private ImmutableList<EquipInfo> equipment;
    private ImmutableList<RunesVo> runes;

    @Override
    public int getExcelId() {
        return idx;
    }


}
