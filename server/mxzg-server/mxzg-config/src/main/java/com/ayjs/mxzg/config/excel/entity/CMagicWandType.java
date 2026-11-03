package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

/**
 * 魔杖类型，洗练技能
 */
@Getter
public class CMagicWandType implements BaseExcelModel {
    // 魔杖配置表id
    private int type_id;
    // 品质
    private int rare;
    // 类型，对应国战类型
    private int type;
    // 基础属性
    private ImmutableMap<AttributeType, Long> base_attrs;
    // 随机属性
    private ImmutableMap<AttributeType, Long> random_attrs;
    // 随机属性最大数
    private int random_attr_max;
    // 洗练消耗
    private ImmutableList<ImmutableThing> cost;
    // 分解返回
    private ImmutableList<ImmutableThing> recover_reward;

    @Override
    public int getExcelId() {
        return type_id;
    }
}
