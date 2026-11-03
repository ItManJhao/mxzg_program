package com.ayjs.mxzg.gameserver.module.godRelic.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2020/3/24
 **/
@Value(staticConstructor = "of")
public class GodRelicPassEvent {
    private long rid;
    private int idx;
}
