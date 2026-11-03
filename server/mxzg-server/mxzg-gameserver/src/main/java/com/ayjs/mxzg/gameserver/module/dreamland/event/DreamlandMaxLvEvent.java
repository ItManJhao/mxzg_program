package com.ayjs.mxzg.gameserver.module.dreamland.event;

import lombok.Value;

/**
 * 永恒梦境最大层数更改事件
 * @author hyx
 */
@Value(staticConstructor = "of")
public class DreamlandMaxLvEvent {
    private long rid;
    private int maxLv;
}
