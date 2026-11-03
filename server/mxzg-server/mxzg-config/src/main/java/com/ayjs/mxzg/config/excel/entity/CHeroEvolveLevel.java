package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/7/15
 **/
@Getter
@Setter
public class CHeroEvolveLevel implements BaseExcelModel {

    /**
     * 标识
     */
    private int idx;
    /**
     * 英雄类型
     */
    private int hero_type;
    /**
     * 进化类型
     */
    private int evolve_type;
    /**
     * 等级
     */
    private int level;
    /**
     * 英雄消耗
     */
    private String consume_hero;
    /**
     * 道具消耗
     */
    private ImmutableList<ImmutableThing> consume_item;
    /**
     * 属性
     */
    private ImmutableMap<AttributeType, Long> attr;
    /**
     * 属性
     */
    private ImmutableMap<AttributeType, Long> attr_show;
    /**
     * 新技能id
     */
    private int skill_id;

    /**
     * 新技能等级
     */
    private int skill_level;
    /**
     * 被替换的技能
     */
    private int skill_old_id;

    @Override
    public int getExcelId() {
        return idx;
    }
}
