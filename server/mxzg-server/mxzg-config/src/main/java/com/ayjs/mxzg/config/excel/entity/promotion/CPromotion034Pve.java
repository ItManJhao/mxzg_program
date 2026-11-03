package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.RunesVo;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * 诸神之战
 */
@Getter
public class CPromotion034Pve implements BaseExcelModel, HeroConfig {

    private int idx;
    private int turns;
    private int mission_type;
    private int mission_id;
    private int hero_type;
    private int pos;
    private long hp;
    private int atk_multiple;
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
