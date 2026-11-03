package com.ayjs.mxzg.config.excel.entity.countrywar;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
public enum CountryWarStage {

    /***
     * 关闭状态
     */
    CLOSE_ING(1),

    /***
     * 战斗中
     */
    WAR(2),

    /***
     * 结算
     */
    SETTLE(3),

    ;
    private int value;

    CountryWarStage(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }

    public static CountryWarStage valueOf(int value) {
        for (CountryWarStage countryWarStage : CountryWarStage.values()) {
            if (countryWarStage.getValue() == value) {
                return countryWarStage;
            }
        }
        throw new RuntimeException("不存在该枚举值：" + value);
    }
}
