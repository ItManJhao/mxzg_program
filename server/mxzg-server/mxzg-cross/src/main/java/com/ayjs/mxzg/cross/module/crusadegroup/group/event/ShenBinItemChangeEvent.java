package com.ayjs.mxzg.cross.module.crusadegroup.group.event;

import lombok.Value;

/**
 * 神兵精华数量增加事件(讨伐团)
 */
@Value(staticConstructor = "of")
public class ShenBinItemChangeEvent {
    private int cgId;//讨伐团id

    private long nowNum;//当前数量
}
