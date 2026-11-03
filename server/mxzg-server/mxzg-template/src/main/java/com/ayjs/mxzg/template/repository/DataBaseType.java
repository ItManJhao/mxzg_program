package com.ayjs.mxzg.template.repository;

/**
 * 数据库类型
 */
public enum DataBaseType {
    /**
     * 游戏服
     */
    Data("data"),
    /**
     * 日志服
     */
    Log("log"),
    ;

    private final String type;

    DataBaseType(String type) {
        this.type = type;
    }

    public String getType() {
        return this.type;
    }

}
