package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

import java.util.HashMap;
import java.util.Map;

/**
 * 羁绊铸魂
 *
 * @author hyx
 */
@Getter
public class CGoddessMakeSoul implements BaseExcelModel {

    private int lv;//羁绊等级

    private ImmutableMap<AttributeType, Long> ability;//单次铸魂属性加成

    private ImmutableList<ImmutableThing> cost_item;

    private int limit;//当前羁绊等级的铸魂次数上限

    @Override
    public int getExcelId() {
        return lv;
    }

    /**
     * 获取当前铸魂的属性加成
     *
     * @param point 铸魂次数
     * @return
     */
    public Map<AttributeType, Long> getAttribute(int point) {
        Map<AttributeType, Long> attributes = new HashMap<>();
        if (point > 0) {
            ability.forEach((k, v) -> {
                attributes.put(k, v * point);
            });
        }
        return attributes;
    }

}
