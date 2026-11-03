package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.EquipInfo;
import com.ayjs.mxzg.config.struct.HeroConfig;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.RunesVo;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * 公会Boss表
 */
@Getter
public class CClanBoss implements BaseExcelModel, HeroConfig {

    private int boss;

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

    private int pos;

    private ImmutableList<AttributeKind> attr;

    private ImmutableList<EquipInfo> equipment;

    private ImmutableList<RunesVo> runes;

    private ImmutableList<ImmutableThing> play_reward;

    private ImmutableList<ImmutableThing> member_reward;

    private ImmutableList<ImmutableThing> killer_reward;

    private ImmutableList<ImmutableThing> killer_exp;

    @Override
    public int getExcelId() {
        return boss;
    }

}
