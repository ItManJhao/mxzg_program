package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 先知抽奖 ，奖池保底
 */
@Getter
public class CProphecyGuarantee implements BaseExcelModel {
    /**
     * 唯一id
     */
    private int idx;
    /**
     * 召唤类型
     */
    private int type;
    /**
     * 类别（1=T1,2=T2,3=T3,4=1~4星英雄）
     */
    private int kind;
    /**
     * 例如：多少次不出T1后，第N次就会出T1英雄
     */
    private int guarantee_times;
    /**
     * 奖池id
     */
    private int reward_group_id;

    @Override
    public int getExcelId() {
        return idx;
    }
}
