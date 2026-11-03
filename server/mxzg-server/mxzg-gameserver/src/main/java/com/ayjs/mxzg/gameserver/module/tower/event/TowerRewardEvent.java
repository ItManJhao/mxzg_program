package com.ayjs.mxzg.gameserver.module.tower.event;

import lombok.Value;

/**
 * 幻境之塔首通领取事件
 */
@Value(staticConstructor = "of")
public class TowerRewardEvent {
    private long rid;
    private int idx;

}
