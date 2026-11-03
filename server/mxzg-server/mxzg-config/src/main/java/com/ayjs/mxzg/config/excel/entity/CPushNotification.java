package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.struct.PushTime;
import lombok.Getter;

/**
 * 推送通知
 */
@Getter
public class CPushNotification implements BaseExcelModel {
    /**
     * ID
     */
    private int idx;
    /**
     * 推送语言
     */
    private String context;//推送文本，
    private String push_name;//标题
    private int push_type;//推送类型1：延时推送  2：定点推送
    private PushTime timeScript;//推送时间脚本
    private int push_open;//推送开关1：开启 0：关闭
    private String opencondition_key;//角色等级限制openKey


    @Override
    public int getExcelId() {
        return idx;
    }

    //判断定点推送时间
    public boolean checkTime_fixed() {
        return timeScript.isTime(idx);
    }

}
