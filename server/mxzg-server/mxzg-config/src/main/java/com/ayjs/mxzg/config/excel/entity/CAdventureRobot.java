package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.RunesVo;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * 勇者试炼机器人
 */
@Getter
public class CAdventureRobot implements BaseExcelModel, HeroConfig {

    /**
     * 关卡id
     */
    private int idx;
    /**
     * 队伍编号
     */
    private int team;
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
    private ImmutableList<AttributeKind> attr;

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
}
