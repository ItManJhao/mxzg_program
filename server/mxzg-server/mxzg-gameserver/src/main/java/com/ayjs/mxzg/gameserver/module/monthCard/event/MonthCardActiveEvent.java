package com.ayjs.mxzg.gameserver.module.monthCard.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/10/19
 **/
@Value(staticConstructor = "of")
public class MonthCardActiveEvent {
    private long rid;
    private int type;
}
