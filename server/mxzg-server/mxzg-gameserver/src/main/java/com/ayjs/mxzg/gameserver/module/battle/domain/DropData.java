package com.ayjs.mxzg.gameserver.module.battle.domain;

import lombok.Data;

/**
 * 掉落数据
 */
@Data
public class DropData {
    /**
     * 周期内获得数量
     */
    private long num;
    /**
     * 轮空次数
     */
    private int missTimes;
}
