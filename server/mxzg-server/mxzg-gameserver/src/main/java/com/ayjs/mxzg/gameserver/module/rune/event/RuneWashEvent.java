package com.ayjs.mxzg.gameserver.module.rune.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2019/10/27
 **/
@Value(staticConstructor = "of")
public class RuneWashEvent {
    private long rid;
}
