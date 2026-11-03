package com.ayjs.mxzg.largecross.module.hades.event;

import lombok.Value;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Value(staticConstructor = "of")
public class HadesChallengeEvent {

    private long rid;
    private int type;
}
