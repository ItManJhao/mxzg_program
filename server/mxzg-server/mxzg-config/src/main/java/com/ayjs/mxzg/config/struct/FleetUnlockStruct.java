package com.ayjs.mxzg.config.struct;

import com.ayjs.mxzg.common.util.IDrop;
import lombok.Getter;

/**
 * 时空冒险解锁航线结构体
 * @author hyx
 */
@Getter
public class FleetUnlockStruct implements IDrop {

    private int unlock_route;

    private int chance;

    @Override
    public int getDropId() {
        return unlock_route;
    }

    @Override
    public int getRate() {
        return chance;
    }
}
