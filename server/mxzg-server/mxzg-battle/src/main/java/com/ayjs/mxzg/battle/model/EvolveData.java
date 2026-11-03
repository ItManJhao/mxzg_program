package com.ayjs.mxzg.battle.model;

import lombok.Getter;
import lombok.Setter;

/**
 * 进化数据
 *
 * @Author: CWJ
 * @Date: 2020/7/17
 **/
@Getter
@Setter
public class EvolveData {

    private int type;
    private int level;

    public static EvolveData of(int type, int level) {
        EvolveData evolveData = new EvolveData();
        evolveData.type = type;
        evolveData.level = level;
        return evolveData;
    }

    public static EvolveData of(EvolveData data) {
        return of(data.getType(), data.level);
    }

}
