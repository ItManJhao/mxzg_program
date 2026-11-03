package com.ayjs.mxzg.gameserver.module.promotionNew.event;

import lombok.Value;

/**
 * 酒馆达标领奖事件
 *
 * @Author: CWJ
 * @Date: 2019/10/24
 **/
@Value(staticConstructor = "of")
public class Promotion032TavernRewardEvent {
    private long rid;
    private int idx;
}
