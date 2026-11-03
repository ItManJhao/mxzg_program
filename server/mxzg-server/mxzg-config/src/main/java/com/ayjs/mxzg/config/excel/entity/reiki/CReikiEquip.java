package com.ayjs.mxzg.config.excel.entity.reiki;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.IHeroPlacingPartConfig;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

import java.util.List;

/**
 * 灵器数据
 */
@Getter
public class CReikiEquip implements BaseExcelModel, IHeroPlacingPartConfig {

    private int idx;

    private int place;

    private int rare;

    /*private int suit_type;*/

    /**
     * 套装id
     */
    private int suit_id;

    private String cost_star_hero;

    private ImmutableList<ImmutableThing> up_star_cost;

    private ImmutableList<Integer> up_star_target;

    private ImmutableList<ImmutableThing> transform_cost;

    private int transform_target;

    /**
     * 基础属性
     */
    private ImmutableMap<AttributeType, Long> ability;

    /**
     * 特殊属性
     */
    private ImmutableMap<AttributeType, Long> special_ability;

    @Override
    public int getExcelId() {
        return idx;
    }

    @Override
    public int getPartItemType() {
        return idx;
    }
}
