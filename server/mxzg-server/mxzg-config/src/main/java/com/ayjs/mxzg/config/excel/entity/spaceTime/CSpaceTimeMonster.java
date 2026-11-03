package com.ayjs.mxzg.config.excel.entity.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.RunesVo;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class CSpaceTimeMonster implements BaseExcelModel, IDrop, HeroConfig {

    private int idx;

    private int route_id;

    private int group_id;

    private int chance;

    private int pos;

    private int hero_type;
    private int hero_level;
    private int hero_star;
    private List<AttributeKind> attr;
    private ImmutableList<EquipInfo> equipment;
    private ImmutableList<RunesVo> runes;

    @Override
    public int getDropId() {
        return group_id;
    }

    @Override
    public int getRate() {
        return chance;
    }

    @Override
    public int getExcelId() {
        return idx;
    }
}
