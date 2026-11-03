package com.ayjs.mxzg.gameserver.module.adven.event;

import lombok.Value;

/**
 * 试炼宝箱开启
 * @author hyx
 */
@Value(staticConstructor = "of")
public class AdvenBoxEvent {

    private long rid;

}
