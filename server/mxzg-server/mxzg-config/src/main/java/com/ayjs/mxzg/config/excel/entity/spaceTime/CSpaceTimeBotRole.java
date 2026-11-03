package com.ayjs.mxzg.config.excel.entity.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

@Getter
public class CSpaceTimeBotRole implements BaseExcelModel {

    private int bot_id;

    private int level;

    private int head;

    private int fighting;

    private String name_lang;

    @Override
    public int getExcelId() {
        return bot_id;
    }
}
