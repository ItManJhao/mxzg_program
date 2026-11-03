package com.ayjs.mxzg.gameserver.module.godRelic.event;

import lombok.Value;
import org.checkerframework.checker.index.qual.LengthOf;

/**
 * @Author: CWJ
 * @Date: 2020/3/24
 **/
@Value(staticConstructor = "of")
public class GodRelicAddStarEvent {
    private long rid;
}
