package com.ayjs.mxzg.gameserver.module.blessingPool.domain;

import lombok.Getter;
import lombok.Setter;

import java.util.Date;

/**
 * @Author: CWJ
 * @Date: 2020/3/2
 **/
@Getter
public class RareLogData {

    private long rid;

    private int itemId;

    private int time;

    public static RareLogData of(long rid, int itemId, int time) {
        RareLogData data = new RareLogData();
        data.rid = rid;
        data.itemId = itemId;
        data.time = time;
        return data;
    }
}
