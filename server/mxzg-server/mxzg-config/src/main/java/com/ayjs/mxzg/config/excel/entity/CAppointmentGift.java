package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

import java.util.List;

@Getter
public class CAppointmentGift implements BaseExcelModel {

    private int idx;

    private int gift_type;

    private List<Integer> versions;

    @Override
    public int getExcelId() {
        return idx;
    }
}
