package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.EffectBuffType;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * 庇护所BUff配置
 */
@Getter
public class CSheltereventBuff implements BaseExcelModel, IDrop {

    private int idx;

    private ImmutableList<EffectBuffType> effect;//收益效果

    private int chance;// 随机概率

    @Override
    public int getExcelId() {
        return idx;
    }

	@Override
	public int getDropId() {
		return idx;
	}

	@Override
	public int getRate() {
		return chance;
	}


}
