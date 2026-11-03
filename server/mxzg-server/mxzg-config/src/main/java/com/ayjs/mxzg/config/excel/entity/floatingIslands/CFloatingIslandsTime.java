package com.ayjs.mxzg.config.excel.entity.floatingIslands;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalTime;

/**
 * @Author: CWJ
 * @Date: 2020/6/30
 **/
@Getter
@Setter
public class CFloatingIslandsTime implements BaseExcelModel {

    private int stage;
    private int week;
    private String stage_time;

    private int intervalTime;

    /***
     * 获取间隔周一0点的间隔时间
     * @return
     */
    public int getIntervalTime() {
        if (intervalTime == 0) {
            LocalTime localDateTime = LocalTime.parse(stage_time.substring(1, stage_time.length() - 1));
            intervalTime = (week - 1) * TimeDateUtil.ONEDAYINT + localDateTime.toSecondOfDay();
        }
        return intervalTime;
    }


    @Override
    public int getExcelId() {
        return stage;
    }


    public static void main(String[] args) {
        LocalTime localDateTime = LocalTime.parse("12:00:00");

        System.out.println(localDateTime.toSecondOfDay());
    }

}
