package com.ayjs.mxzg.gameserver.module.runeStone.struct;

import com.ayjs.mxzg.config.excel.entity.runeStone.CRuneStoneExtraAptitude;
import lombok.Value;

/**
 *
 * @Author: CWJ
 * @Date: 2020/7/29
 **/
@Value(staticConstructor = "of")
public class RuneStoneAptitude {

    /**
     * @see CRuneStoneExtraAptitude#idx
     */
    private int idx;

    private long value;

    public static RuneStoneAptitude defaultExtraAttr() {
        return RuneStoneAptitude.of(0, 0);
    }

}
