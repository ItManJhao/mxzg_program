package com.ayjs.mxzg.gameserver.module.runeStone.struct;

import lombok.Getter;
import lombok.Setter;

/**
 * 符石格子
 *
 * @Author: CWJ
 * @Date: 2020/7/29
 **/
@Getter
@Setter
public class RuneStoneExtraGrid {

    private int place;

    private RuneStoneAptitude extraAptitude;

    public static RuneStoneExtraGrid valueOf(int place) {
        RuneStoneExtraGrid grid = new RuneStoneExtraGrid();
        grid.place = place;
        return grid;
    }

}
