package com.ayjs.mxzg.config.excel.entity.hades;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Getter
public class CHadesFloor implements BaseExcelModel {

    private int idx;
    private int type;
    private int floor;
    private int difficulty_lv;
    private int show_floor;
    private ImmutableList<ImmutableThing> pass_reward;
    private ImmutableList<ImmutableThing> cost;
    private ImmutableList<ImmutableThing> sweep_reward;
    private String battle_name;

    @Override
    public int getExcelId() {
        return idx;
    }
}
