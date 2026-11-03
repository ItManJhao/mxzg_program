package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

@Getter
public class CAdventureRobotRole implements BaseExcelModel {
    /**
     * 队伍id
     */
    private int team;
    /**
     * 机器人等级
     */
    private int level;
    /**
     * 机器人头像
     */
    private int head;
    /**
     * 机器人战力
     */
    private long fighting;

    @Override
    public int getExcelId() {
        return team;
    }
}
