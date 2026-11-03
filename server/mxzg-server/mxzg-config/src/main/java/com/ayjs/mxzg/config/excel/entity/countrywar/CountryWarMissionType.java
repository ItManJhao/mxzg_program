package com.ayjs.mxzg.config.excel.entity.countrywar;

/**
 * @Author: CWJ
 * @Date: 2021/4/23
 **/
public enum CountryWarMissionType {

    //一天
    ONE_DAY(1, 1),
    //五天
    FIVE_DAY(2, 5),
    //永久不刷新
    NEVER(3, 360),
    ;
    private int type;
    private int day;

    CountryWarMissionType(int type, int day) {
        this.type = type;
        this.day = day;
    }

    public int getDay() {
        return day;
    }

    public int getType() {
        return type;
    }

    public static CountryWarMissionType typeOf(int type) {
        for (CountryWarMissionType missionType : CountryWarMissionType.values()) {
            if (missionType.getType() == type) {
                return missionType;
            }
        }
        throw new RuntimeException("不存在该类型：" + type);
    }
}
