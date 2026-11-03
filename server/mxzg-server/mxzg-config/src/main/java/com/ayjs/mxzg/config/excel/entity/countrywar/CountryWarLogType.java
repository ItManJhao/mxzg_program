package com.ayjs.mxzg.config.excel.entity.countrywar;

/**
 * @Author: CWJ
 * @Date: 2021/4/25
 **/
public enum CountryWarLogType {
    /***
     * 联盟日志
     */
    LOG_1(1),
    /***
     * 成功防御5次
     */
    LOG_2(2),
    /***
     * 联盟解散
     */
    LOG_3(3),
    /***
     * 城池失守日志
     */
    LOG_4(4),
    /***
     * 占领日志
     */
    LOG_5(5),
    /***
     * 被打败日志
     */
    LOG_6(6),
    /***
     * 玩家防守成功日志
     */
    LOG_7(7),
    /***
     * 玩家攻击成功占领日志
     */
    LOG_8(8),
    /***
     * 玩家成功防守5次
     */
    LOG_9(9),
    ;

    private int value;

    CountryWarLogType(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
