package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.RunesVo;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

@Getter
public class CDailyMission implements BaseExcelModel, HeroConfig {
    /**
     * 唯一id
     */
    private int idx;
    /**
     * 副本类型
     * 1 金币副本， 2经验副本， 3英雄副本，4羁绊副本，5精灵（符文）副本
     */
    private int mission_type;
    /**
     * 关卡id
     */
    private int mission_id;
    /**
     * 站位
     */
    private int pos;

    /**
     * 怪物id
     */
    private int hero_type;

    /**
     * 怪物等级
     */
    private int hero_level;

    /**
     * 怪物星际
     */
    private int hero_star;

    /**
     * 属性
     */
    private ImmutableList<AttributeKind> attr;

    /**
     * 装备
     */
    private ImmutableList<EquipInfo> equipment;

    /**
     * 精灵
     */
    private ImmutableList<RunesVo> runes;

    @Override
    public int getExcelId() {
        return idx;
    }
}
