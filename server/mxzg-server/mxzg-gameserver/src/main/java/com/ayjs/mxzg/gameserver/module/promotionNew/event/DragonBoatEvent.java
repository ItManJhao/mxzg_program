package com.ayjs.mxzg.gameserver.module.promotionNew.event;

import lombok.Value;

/**
 * 龙舟活动翻牌事件
 *
 * @author hyx
 */
@Value(staticConstructor = "of")
public class DragonBoatEvent {

    private long rid;

}
