package com.ayjs.mxzg.config.excel.entity.magicTower;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.RunesVo;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Getter
public class CMagicTowerLevel implements BaseExcelModel, HeroConfig {

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
