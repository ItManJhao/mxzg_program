package com.ayjs.mxzg.config.excel.entity.hades;

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
 * @Date: 2021/1/6
 **/
@Getter
public class CHadesMonster implements HeroConfig, BaseExcelModel {

    /**
     * 关卡id
     */
    private int idx;

    /**
     * 关卡索引
     */
    private int floor_idx;
    /**
     * 怪物站位
     */
    private int pos;
    /**
     * 怪物类型
     */
    private int hero_type;
    /**
     * 怪物等级
     */
    private int hero_level;
    /**
     * 怪物星级
     */
    private int hero_star;
    /**
     * 星际
     */
    private ImmutableList<AttributeKind> boss_attr;

    /**
     * 装备
     */
    private ImmutableList<EquipInfo> equipment;

    /**
     * 铭文
     */
    private ImmutableList<RunesVo> runes;

    @Override
    public int getExcelId() {
        return idx;
    }

    @Override
    public List<AttributeKind> getAttr() {
        return boss_attr;
    }
}
