package com.ayjs.mxzg.config.excel.entity.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import lombok.Getter;

@Getter
public class CSpaceTimeEvent implements BaseExcelModel {

    private int event_id;

    private int nick_language_id;

    private int details_language_id;

    /**
     * 1：显示， 0：不显示
     */
    private int is_show;

    @Override
    public int getExcelId() {
        return event_id;
    }
}
