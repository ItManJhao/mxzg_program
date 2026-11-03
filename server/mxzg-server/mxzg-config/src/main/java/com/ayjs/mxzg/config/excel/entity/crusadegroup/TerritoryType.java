package com.ayjs.mxzg.config.excel.entity.crusadegroup;

import com.ayjs.mxzg.common.convert.annotation.EnumMode;
import com.ayjs.mxzg.common.convert.annotation.ValueMode;

/**
 * 领地类型
 */
@EnumMode(ValueMode.VALUE)
public enum TerritoryType {

    /** 普通可占领的 */
    ORDINARY(1),

    /** 关隘不可占领 */
    PASS(2),

    /** Boss不可占领 */
    BOSS(3);

    private int code;

    private TerritoryType(int code){
        this.code = code;
    }

    public int getCode(){
        return this.code;
    }
}
