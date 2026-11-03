package com.ayjs.mxzg.config.struct;

/**
 * @Author: CWJ
 * @Date: 2020/7/21
 **/
public enum GoddessFashionUnlockType {

    TASK(1),
    ITEM(2),

    ;
    private int code;

    GoddessFashionUnlockType(int code) {
        this.code = code;
    }

    public int getCode() {
        return code;
    }
}
