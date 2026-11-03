package com.ayjs.mxzg.largecross.module.promotion092.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/3/11
 **/
@Value(staticConstructor = "of")
public class DeliverFlowerEvent {

    private long rid;
    private int heroType;
}
