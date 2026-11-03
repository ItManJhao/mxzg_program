package com.ayjs.mxzg.config.excel.entity.promotion070;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Getter
public class CPromotion070Type implements BaseExcelModel {

    private int idx;
    private int num;
    /**
     * 多少次后才出
     */
    private int min_count;
    /**
     * 多少次内必出
     */
    private int max_count;
    /**
     * 是否需要客户端选择奖励，不需要的话，服务器从对应的奖励里面随机抽取奖励id
     */

    private int client;


    @Override
    public int getExcelId() {
        return idx;
    }
}
