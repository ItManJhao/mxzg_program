package com.ayjs.mxzg.gameserver.module.tower.event;

import lombok.Value;

/**
 * 爬塔扫荡
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class TowerSweepEvent {
    private long rid;
    /**扫荡层数*/
    private int count;
}
