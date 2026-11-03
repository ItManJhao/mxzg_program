package com.ayjs.mxzg.config.excel.entity.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.RunesVo;
import com.google.common.collect.ImmutableList;
import lombok.Getter;


@Getter
public class CSpaceTimeBot implements BaseExcelModel, HeroConfig {

    private int idx;
    private int bot_id;
    private int lineup_type;
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
