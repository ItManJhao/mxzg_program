package com.ayjs.mxzg.config.excel.entity.reiki;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 灵器槽位激活配置表
 * @author hyx
 */
@Getter
public class CReikiEquipActive implements BaseExcelModel {

    private int place;

    private int start;

    private int level;

    private ImmutableList<ImmutableThing> cost_item;

    private int reiki_equip_id;

    @Override
    public int getExcelId() {
        return place;
    }
}
