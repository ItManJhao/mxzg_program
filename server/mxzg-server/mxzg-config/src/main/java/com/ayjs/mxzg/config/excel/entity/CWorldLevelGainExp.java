package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ThingBonus;
import lombok.Getter;

import java.util.List;

/**
 * 世界等级加经验加成
 * @author hyx
 */
@Getter
public class CWorldLevelGainExp implements BaseExcelModel {

    private int idx;

    private int level_up;

    private int level_down;

    private List<ThingBonus> bonus;

    @Override
    public int getExcelId() {
        return idx;
    }
}
