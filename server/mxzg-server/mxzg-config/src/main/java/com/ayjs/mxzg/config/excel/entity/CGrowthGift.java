package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

@Getter
public class CGrowthGift implements BaseExcelModel {

	private int idx;

	private int need_recharge;

	private int show_need_recharge;

    private ImmutableList<ImmutableThing> gem_pack;

    private ImmutableList<ImmutableThing> pack_cost;

    private ImmutableList<ImmutableThing> gift_every_day;

    private ImmutableList<ImmutableThing> decorate_item;

    @Override
    public int getExcelId() {
        return idx;
    }
}
